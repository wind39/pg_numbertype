EXTENSION = pg_numbertype
DATA = pg_numbertype--0.0.1.sql
MODULES = pg_numbertype

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
INCLUDEDIR := $(shell $(PG_CONFIG) --includedir)
INCLUDEDIR-SERVER := $(shell $(PG_CONFIG) --includedir-server)
include $(PGXS)

pg_numbertype.so: pg_numbertype.c
	gcc -fPIC -c -o pg_numbertype.o pg_numbertype.c -I $(INCLUDEDIR) -I $(INCLUDEDIR-SERVER)
	gcc -fPIC -o pg_numbertype.so pg_numbertype.o -shared
