#!/usr/bin/env python3

# FLASK_APP=ftpython flask run \
#     --reload --no-debugger --eager-loading --with-threads \
#     --host=127.0.0.1 --port=8080
# python3 -m pip install --user flask
# python3 ftpython

# from OpenSSL import SSL
import os

from flask import Flask, flash, request, redirect, url_for
from werkzeug.middleware.shared_data import SharedDataMiddleware
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = os.getcwd()
ALLOWED_EXTENSIONS = {"txt", "pdf", "png", "jpg", "jpeg", "gif"}

FORM_TEMPLATE = """<!doctype html>
<html>
    <head>
        <title>Upload new File</title>
    </head>
    <body>
        <h1>Upload new File</h1>
        <form method=post enctype=multipart/form-data>
            <input type=file name=file>
            <input type=submit value=Upload>
        </form>
    </body>
</html>"""

# context = SSL.Context(SSL.PROTOCOL_TLSv1_2)
# context.use_privatekey_file("server.key")
# context.use_certificate_file("server.crt")

app = Flask(__name__)
app.config["SECRET_KEY"] = "the random string"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {"/uploads": app.config["UPLOAD_FOLDER"], })
app.add_url_rule("/uploads/<filename>", "uploaded_file", build_only=True)


@app.route("/", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        # check if the post request has the file part
        if "file" not in request.files:
            flash("No file part")
            return redirect(request.url)
        file = request.files["file"]
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == "":
            flash("No selected file")
            return redirect(request.url)
        if file and allowed(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            return redirect(url_for("uploaded_file", filename=filename))
    return FORM_TEMPLATE


def allowed(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port="8080",
        debug=False,
        load_dotenv=False,
        use_reloader=False,
        use_debugger=False,
        threaded=True,
        # ssl_context=context,
    )
