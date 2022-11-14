#!/usr/bin/env python3

import logging

from asyncio import Event
from asyncio import Queue
from asyncio import create_task
from asyncio import gather
from asyncio import run
from asyncio.exceptions import CancelledError
from functools import partial
from typing import Any
from typing import Callable
from typing import Coroutine

from httpx import AsyncClient
from pyquery import PyQuery


logging.basicConfig()
logger = logging.getLogger(__name__)


visited: set[str] = set()


async def main():
    queue_request_urls = Queue()
    queue_extract_urls = Queue()
    queue_print_title = Queue()
    event_completed = Event()

    await queue_request_urls.put(("https://hellupline.dev/", "https://hellupline.dev/"))

    async with AsyncClient() as client:
        f_request_url = partial(
            _request_url,
            client=client,
            queue_output=queue_extract_urls,
        )
        f_extract_data = partial(
            _extract_data,
            event_completed=event_completed,
            queue_output_1=queue_request_urls,
            queue_output_2=queue_print_title,
        )
        tasks_request_urls = [
            create_task(queue_task(queue_input=queue_request_urls, task_index=i, function=f_request_url))
            for i in range(4)
        ]
        tasks_extract_urls = [
            create_task(queue_task(queue_input=queue_extract_urls, task_index=i, function=f_extract_data))
            for i in range(4)
        ]
        tasks_print_title = [
            create_task(queue_task(queue_input=queue_print_title, task_index=i, function=_print_title))
            for i in range(4)
        ]

        await event_completed.wait()

        await queue_request_urls.join()
        for task in tasks_request_urls:
            task.cancel()
        await gather(*tasks_request_urls)
        logger.debug("request done")

        await queue_extract_urls.join()
        for task in tasks_extract_urls:
            task.cancel()
        await gather(*tasks_extract_urls)
        logger.debug("extract done")

        await queue_print_title.join()
        for task in tasks_print_title:
            task.cancel()
        await gather(*tasks_print_title)
        logger.debug("print done")


async def queue_task(
    queue_input: Queue,
    task_index: int,
    function: Callable[..., Coroutine[Any, Any, Any]],
):
    logger.debug(f"{function.__name__}({task_index}) started")
    while True:  # not queue_input.empty()
        try:
            data = await queue_input.get()
        except CancelledError:
            logger.debug(f"{function.__name__}({task_index}) cancelled")
            return
        logger.debug(f"{function.__name__}({task_index}) extracting urls")
        try:
            await function(data=data)
        except Exception:  # pylint: disable=broad-except
            logger.exception(f"{function.__name__}({task_index}) failed to run task")  # raise
        finally:
            queue_input.task_done()


async def _request_url(
    data: tuple[str, str],
    client: AsyncClient,
    queue_output: Queue,
):
    url, base_url = data
    r = await client.request(method="GET", url=url)
    await queue_output.put((r.text, base_url))


async def _extract_data(
    data: tuple[str, str],
    event_completed: Event,
    queue_output_1: Queue,
    queue_output_2: Queue,
):
    text, base_url = data
    q = PyQuery(text).make_links_absolute(base_url=base_url)
    urls = {
        url
        for url in (tag.attrib.get("href", "") for tag in q("a"))
        if url.startswith(base_url) and url.endswith("/")
    } - visited
    title = q("title").text().strip()
    visited.update(urls)
    for url in urls:
        await queue_output_1.put((url, base_url))
    if not urls:
        event_completed.set()
    await queue_output_2.put(title)


async def _print_title(data: str):
    print("title:", data)


if __name__ == "__main__":
    run(main())
