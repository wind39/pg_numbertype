/*-------------------------------------------------------------------------
 *
 * pg_numbertype
 *    A simple NUMBER implementation for demonstration purposes.
 *
 * Copyright (c) 2025, William Ivanski
 *
 *-------------------------------------------------------------------------
 */


\echo Use "CREATE EXTENSION pg_numbertype" to load this file. \quit

-- BASE TYPE

CREATE TYPE public."number";

CREATE FUNCTION number_in(cstring)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION number_out(number)
    RETURNS cstring
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE public."number" (
    INPUT = number_in
    , OUTPUT = number_out
    , INTERNALLENGTH = 8
    , ALIGNMENT = double
    , CATEGORY = N
);


-- CASTS

CREATE CAST (smallint AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (integer AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (bigint AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (real AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (double precision AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (money AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (numeric AS number)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (number AS numeric)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (number AS real)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (number AS double precision)
    WITH INOUT
    AS IMPLICIT;

CREATE CAST (number AS money)
    WITH INOUT
    AS IMPLICIT;

CREATE FUNCTION number_smallint(number)
    RETURNS smallint
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE CAST (number AS smallint)
    WITH FUNCTION number_smallint(number);

CREATE FUNCTION number_integer(number)
    RETURNS integer
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE CAST (number AS integer)
    WITH FUNCTION number_integer(number);

CREATE FUNCTION number_bigint(number)
    RETURNS bigint
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE CAST (number AS bigint)
    WITH FUNCTION number_bigint(number);


-- OPERATORS

CREATE FUNCTION number_abs(number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR @ (
    FUNCTION   = number_abs,
    RIGHTARG   = number
);

CREATE FUNCTION number_uminus(number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR - (
    FUNCTION   = number_uminus,
    RIGHTARG   = number
);

CREATE FUNCTION number_uplus(number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR + (
    FUNCTION   = number_uplus,
    RIGHTARG   = number
);

CREATE FUNCTION number_add(number, number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR + (
    FUNCTION   = number_add,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = +
);

CREATE FUNCTION number_sub(number, number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR - (
    FUNCTION   = number_sub,
    LEFTARG    = number,
    RIGHTARG   = number
);

CREATE FUNCTION number_mul(number, number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR * (
    FUNCTION   = number_mul,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = *
);

CREATE FUNCTION number_div(number, number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR / (
    FUNCTION   = number_div,
    LEFTARG    = number,
    RIGHTARG   = number
);

CREATE FUNCTION number_mod(number, number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR % (
    FUNCTION   = number_mod,
    LEFTARG    = number,
    RIGHTARG   = number
);

CREATE FUNCTION number_power(number, number)
    RETURNS number
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR ^ (
    FUNCTION   = number_power,
    LEFTARG    = number,
    RIGHTARG   = number
);

CREATE FUNCTION number_eq(number, number)
    RETURNS bool
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR = (
    FUNCTION   = number_eq,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = =,
    NEGATOR    = <>
);

CREATE FUNCTION number_ne(number, number)
    RETURNS bool
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR <> (
    FUNCTION   = number_ne,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = <>,
    NEGATOR    = =
);

CREATE FUNCTION number_gt(number, number)
    RETURNS bool
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR > (
    FUNCTION   = number_gt,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = <,
    NEGATOR    = <=
);

CREATE FUNCTION number_lt(number, number)
    RETURNS bool
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR < (
    FUNCTION   = number_lt,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = >,
    NEGATOR    = >=
);

CREATE FUNCTION number_ge(number, number)
    RETURNS bool
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR >= (
    FUNCTION   = number_ge,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = <=,
    NEGATOR    = <
);

CREATE FUNCTION number_le(number, number)
    RETURNS bool
    AS '$libdir/pg_numbertype'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR <= (
    FUNCTION   = number_le,
    LEFTARG    = number,
    RIGHTARG   = number,
    COMMUTATOR = >=,
    NEGATOR    = >
);
