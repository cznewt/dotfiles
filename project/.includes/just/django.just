#!/usr/bin/env just --justfile

django_cmd := "docker run -it --rm=true --network host -v $CURRENT_DIR:/app -e DJANGO_SETTINGS_MODULE=config.settings.dev"
django_image := "$REGISTRY_NAME/$IMAGE_NAME-dev:$IMAGE_TAG"

[doc('Execute to Django server container.')]
[group('django lib')]
exec-app:
    @{{django_cmd}} {{django_image}} bash

[doc('Execute Django `manage.py` command.')]
[group('django lib')]
manage-app *args:
    @{{django_cmd}} {{django_image}}  python ./manage.py {{args}}

[doc('Run Django server container.')]
[group('django lib')]
run-app:
    @sudo mkdir -p "$CURRENT_DIR/data/django/cache"
    @sudo chown 1000:1000 $CURRENT_DIR/data/django -R
    @echo "Running django lib server..."
    @{{django_cmd}} {{django_image}} run-django-server

[doc('Run Celery worker container with single concurrency.')]
[group('django lib')]
run-worker:
    @echo "Running Celery worker..."
    @{{django_cmd}} {{django_image}} run-celery-worker

[doc('Preview, create and apply django lib migrations.')]
[group('django lib')]
update-migrations:
    @echo "Showing applicable Django migrations..."
    @sudo mkdir -p "$CURRENT_DIR/data/django/cache"
    @sudo chown 1000:1000 $CURRENT_DIR/data/django -R
    @sudo chown 1000:1000 $CURRENT_DIR/docker/files/app/website/migrations -R
    @{{django_cmd}} {{django_image}} update-django-migrations
    @sudo chown $(id -u):$(id -g) $CURRENT_DIR/docker/files/app/website/migrations -R

[doc('Make and compile django lib translation files.')]
[group('django lib')]
update-translations:
    @echo "Making and compiling Django translation files..."
    @{{django_cmd}} {{django_image}} update-django-translations

[doc('Create django lib superuser.')]
[group('django lib')]
create-admin:
    @echo "Creating django lib superuser..."
    @{{django_cmd}} {{django_image}} create-django-admin

[doc('Dump django lib database.')]
[group('django lib')]
dump-database:
    @echo "Dumping Django database..."
    @{{django_cmd}} {{django_image}} dump-django-database

[doc('Compile and watch django lib SASS files.')]
[group('django lib')]
compile-sass:
    @echo "Compiling and watching Django SASS files..."
    @{{django_cmd}} {{django_image}} compile-django-sass-files

[doc('List installed Python packages.')]
[group('django lib')]
list-packages:
    @{{django_cmd}} {{django_image}} version
