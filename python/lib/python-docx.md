# [python-docx](https://python-docx.readthedocs.io/en/latest/)

- [python-docx](#python-docx)
  - [Install](#install)
  - [Demo](#demo)

python-docx is a Python library for creating and updating Microsoft Word (.docx) files.

## Install

    pip3 install python-docx 

## Demo

    from docx import Document

    docx_file_path = '../foo.docx'
    document = Document(docx_file_path)
    for paragraph in document.paragraphs:
        print(paragraph.text)
