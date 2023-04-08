import os
import uuid
from django.db import models


def post_img_path_generator(instance, filename):

    ext = os.path.splitext(filename)[1]
    return os.path.join('posts/img', f'{uuid.uuid1()}{ext}')


class Post(models.Model):
    author = models.CharField(max_length=20)
    description = models.CharField(max_length=255)
    img = models.ImageField(upload_to=post_img_path_generator)
