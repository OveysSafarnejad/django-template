from django.contrib import admin

# Register your models here.

from apps.post.models import Post

admin.site.register(Post)
