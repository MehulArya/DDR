import csv
import os
from django.core.management.base import BaseCommand
from faculty.models import FacultyTeacher
from django.conf import settings


class Command(BaseCommand):
    help = "Import faculty emails from emails.csv into faculty_teacher table"

    def handle(self, *args, **kwargs):
        # CSV file path (inside project root)
        csv_path = os.path.join(settings.BASE_DIR, "emails.csv")

        if not os.path.exists(csv_path):
            self.stdout.write(self.style.ERROR(f"File not found: {csv_path}"))
            return

        with open(csv_path, mode="r", encoding="utf-8") as f:
            reader = csv.DictReader(f)

            created_count = 0
            updated_count = 0
            skipped = 0

            for row in reader:
                # normalize headers (strip spaces, lowercase)
                row = {k.strip().lower(): (v.strip() if v else "") for k, v in row.items()}

                name = row.get("name")
                email = row.get("email")

                if not email or not name:
                    skipped += 1
                    continue

                # check if teacher exists
                obj, created = FacultyTeacher.objects.update_or_create(
                    email=email,
                    defaults={"name": name}
                )

                if created:
                    created_count += 1
                else:
                    updated_count += 1

            self.stdout.write(
                self.style.SUCCESS(
                    f"Imported {created_count} new teachers, "
                    f"updated {updated_count}, skipped {skipped}"
                )
            )
