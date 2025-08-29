from django.db import models

class Teacher(models.Model):
    serial_no = models.IntegerField(null=True, blank=True)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)

    def __str__(self):
        return f"{self.name} ({self.email})"
