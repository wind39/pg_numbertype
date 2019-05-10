\echo Use "CREATE EXTENSION pg_numbertype" to load this file. \quit

-- BASE TYPE

CREATE TYPE public."number";

CREATE FUNCTION public.number_in(cstring, oid, integer) RETURNS number LANGUAGE INTERNAL IMMUTABLE PARALLEL SAFE STRICT AS 'numeric_in';
CREATE FUNCTION public.number_out(number) RETURNS cstring LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT AS '$libdir/pg_numbertype';
CREATE FUNCTION public.number_recv(internal, oid, integer) RETURNS number LANGUAGE INTERNAL IMMUTABLE PARALLEL SAFE STRICT AS 'numeric_recv';
CREATE FUNCTION public.number_send(number) RETURNS bytea LANGUAGE INTERNAL IMMUTABLE PARALLEL SAFE STRICT AS 'numeric_send';

CREATE TYPE public."number" (
    INPUT = number_in
    , OUTPUT = number_out
    , RECEIVE = number_recv
    , SEND = number_send
    , TYPMOD_IN = numerictypmodin
    , TYPMOD_OUT = numerictypmodout
    , LIKE = numeric
);


-- CASTS

/*
select format(
           $$CREATE FUNCTION public."%s"(number) RETURNS %s LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS '%s';$$,
           (case when p.proname = 'numeric' then 'number' else p.proname end),
           (case when format_type(p.prorettype, null) = 'numeric' then 'number' else format_type(p.prorettype, null) end),
           p.prosrc
       ) as f,
       format(
           $$CREATE CAST (number AS %s) WITH FUNCTION %s AS %s;$$,
           (case when format_type(p.prorettype, null) = 'numeric' then 'number' else format_type(p.prorettype, null) end),
           format($$public."%s"(number)$$, (case when p.proname = 'numeric' then 'number' else p.proname end)),
           (case when c.castcontext = 'a' then 'ASSIGNMENT' else 'IMPLICIT' end)
       ) as a
from pg_cast c
inner join pg_proc p
on p.oid = c.castfunc
where c.castsource = 'numeric'::regtype
  and format_type(p.prorettype, null) <> 'numeric'
union
select format(
           $$CREATE FUNCTION public."%s"(%s) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS '%s';$$,
           (case when p.proname = 'numeric' then 'number' else p.proname end),
           pg_get_function_identity_arguments(p.oid),
           p.prosrc
       ) as f,
       format(
           $$CREATE CAST (%s AS number) WITH FUNCTION %s AS %s;$$,
           pg_get_function_identity_arguments(p.oid),
           format($$public."%s"(%s)$$, (case when p.proname = 'numeric' then 'number' else p.proname end), pg_get_function_identity_arguments(p.oid)),
           (case when c.castcontext = 'a' then 'ASSIGNMENT' else 'IMPLICIT' end)
       ) as a
from pg_cast c
inner join pg_proc p
on p.oid = c.castfunc
where c.casttarget = 'numeric'::regtype
  and pg_get_function_identity_arguments(p.oid) <> 'numeric, integer'
union
select $$CREATE FUNCTION public."numeric"(number) RETURNS numeric LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric';$$ as f,
       $$CREATE CAST (number AS numeric) WITH FUNCTION public."numeric"(number) AS IMPLICIT;$$ as a
union
select $$CREATE FUNCTION public."number"(numeric) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric';$$ as f,
       $$CREATE CAST (numeric AS number) WITH FUNCTION public."number"(numeric) AS IMPLICIT;$$ as a
order by 2
*/

CREATE FUNCTION public."number"(bigint) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'int8_numeric';
CREATE FUNCTION public."number"(double precision) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'float8_numeric';
CREATE FUNCTION public."number"(integer) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'int4_numeric';
CREATE FUNCTION public."number"(money) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'cash_numeric';
CREATE FUNCTION public."int8"(number) RETURNS bigint LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_int8';
CREATE FUNCTION public."float8"(number) RETURNS double precision LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_float8';
CREATE FUNCTION public."int4"(number) RETURNS integer LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_int4';
CREATE FUNCTION public."money"(number) RETURNS money LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_cash';
CREATE FUNCTION public."numeric"(number) RETURNS numeric LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric';
CREATE FUNCTION public."float4"(number) RETURNS real LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_float4';
CREATE FUNCTION public."int2"(number) RETURNS smallint LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_int2';
CREATE FUNCTION public."number"(numeric) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric';
CREATE FUNCTION public."number"(real) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'float4_numeric';
CREATE FUNCTION public."number"(smallint) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'int2_numeric';

CREATE CAST (bigint AS number) WITH FUNCTION public."number"(bigint) AS IMPLICIT;
CREATE CAST (double precision AS number) WITH FUNCTION public."number"(double precision) AS ASSIGNMENT;
CREATE CAST (integer AS number) WITH FUNCTION public."number"(integer) AS IMPLICIT;
CREATE CAST (money AS number) WITH FUNCTION public."number"(money) AS ASSIGNMENT;
CREATE CAST (number AS bigint) WITH FUNCTION public."int8"(number) AS ASSIGNMENT;
CREATE CAST (number AS double precision) WITH FUNCTION public."float8"(number) AS IMPLICIT;
CREATE CAST (number AS integer) WITH FUNCTION public."int4"(number) AS ASSIGNMENT;
CREATE CAST (number AS money) WITH FUNCTION public."money"(number) AS ASSIGNMENT;
CREATE CAST (number AS numeric) WITH FUNCTION public."numeric"(number) AS IMPLICIT;
CREATE CAST (number AS real) WITH FUNCTION public."float4"(number) AS IMPLICIT;
CREATE CAST (number AS smallint) WITH FUNCTION public."int2"(number) AS ASSIGNMENT;
CREATE CAST (numeric AS number) WITH FUNCTION public."number"(numeric) AS IMPLICIT;
CREATE CAST (real AS number) WITH FUNCTION public."number"(real) AS ASSIGNMENT;
CREATE CAST (smallint AS number) WITH FUNCTION public."number"(smallint) AS IMPLICIT;


-- OPERATORS

/*
select format(
           $$CREATE FUNCTION public."%s"(%s) RETURNS %s LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS '%s';$$,
           replace(p.proname, 'numeric', 'number'),
           replace(pg_get_function_identity_arguments(p.oid), 'numeric', 'number'),
           (case when format_type(p.prorettype, null) = 'numeric' then 'number' else format_type(p.prorettype, null) end),
           p.prosrc
       ) as f,
       format(
           $$CREATE OPERATOR %s (PROCEDURE = %s%s%s%s%s%s%s%s%s);$$,
           o.oprname,
           format($$public."%s"$$, replace(p.proname, 'numeric', 'number')),
           (case when o.oprkind = 'b' then ', LEFTARG = number' else '' end),
           ', RIGHTARG = number',
           (case when c.oprname is not null then format(', COMMUTATOR = %s', c.oprname) else '' end),
           (case when n.oprname is not null then format(', NEGATOR = %s', n.oprname) else '' end),
           (case when o.oprrest is not null and o.oprrest <> '-'::regprocedure then format(', RESTRICT = %s', o.oprrest) else '' end),
           (case when o.oprjoin is not null and o.oprjoin <> '-'::regprocedure then format(', JOIN = %s', o.oprjoin) else '' end),
           (case when o.oprcanhash then ', HASHES' else '' end),
           (case when o.oprcanmerge then ', MERGES' else '' end)
       ) as x
from pg_operator o
inner join pg_proc p
on p.oid = o.oprcode
left join pg_operator c
on c.oid = o.oprcom
left join pg_operator n
on n.oid = o.oprnegate
where o.oprleft = 'numeric'::regtype
   or o.oprright = 'numeric'::regtype
order by 2
*/

CREATE FUNCTION public."number_abs"(number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_abs';
CREATE FUNCTION public."number_add"(number, number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_add';
CREATE FUNCTION public."number_div"(number, number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_div';
CREATE FUNCTION public."number_eq"(number, number) RETURNS boolean LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_eq';
CREATE FUNCTION public."number_ge"(number, number) RETURNS boolean LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_ge';
CREATE FUNCTION public."number_gt"(number, number) RETURNS boolean LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_gt';
CREATE FUNCTION public."number_le"(number, number) RETURNS boolean LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_le';
CREATE FUNCTION public."number_lt"(number, number) RETURNS boolean LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_lt';
CREATE FUNCTION public."number_mod"(number, number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_mod';
CREATE FUNCTION public."number_mul"(number, number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_mul';
CREATE FUNCTION public."number_ne"(number, number) RETURNS boolean LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_ne';
CREATE FUNCTION public."number_power"(number, number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_power';
CREATE FUNCTION public."number_sub"(number, number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_sub';
CREATE FUNCTION public."number_uminus"(number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_uminus';
CREATE FUNCTION public."number_uplus"(number) RETURNS number LANGUAGE INTERNAL STABLE PARALLEL SAFE STRICT AS 'numeric_uplus';

CREATE OPERATOR @ (PROCEDURE = public."number_abs", RIGHTARG = number);
CREATE OPERATOR + (PROCEDURE = public."number_add", LEFTARG = number, RIGHTARG = number, COMMUTATOR = +);
CREATE OPERATOR / (PROCEDURE = public."number_div", LEFTARG = number, RIGHTARG = number);
CREATE OPERATOR = (PROCEDURE = public."number_eq", LEFTARG = number, RIGHTARG = number, COMMUTATOR = =, NEGATOR = <>, RESTRICT = eqsel, JOIN = eqjoinsel, HASHES, MERGES);
CREATE OPERATOR >= (PROCEDURE = public."number_ge", LEFTARG = number, RIGHTARG = number, COMMUTATOR = <=, NEGATOR = <, RESTRICT = scalargtsel, JOIN = scalargtjoinsel);
CREATE OPERATOR > (PROCEDURE = public."number_gt", LEFTARG = number, RIGHTARG = number, COMMUTATOR = <, NEGATOR = <=, RESTRICT = scalargtsel, JOIN = scalargtjoinsel);
CREATE OPERATOR <= (PROCEDURE = public."number_le", LEFTARG = number, RIGHTARG = number, COMMUTATOR = >=, NEGATOR = >, RESTRICT = scalarltsel, JOIN = scalarltjoinsel);
CREATE OPERATOR < (PROCEDURE = public."number_lt", LEFTARG = number, RIGHTARG = number, COMMUTATOR = >, NEGATOR = >=, RESTRICT = scalarltsel, JOIN = scalarltjoinsel);
CREATE OPERATOR % (PROCEDURE = public."number_mod", LEFTARG = number, RIGHTARG = number);
CREATE OPERATOR * (PROCEDURE = public."number_mul", LEFTARG = number, RIGHTARG = number, COMMUTATOR = *);
CREATE OPERATOR <> (PROCEDURE = public."number_ne", LEFTARG = number, RIGHTARG = number, COMMUTATOR = <>, NEGATOR = =, RESTRICT = neqsel, JOIN = neqjoinsel);
CREATE OPERATOR ^ (PROCEDURE = public."number_power", LEFTARG = number, RIGHTARG = number);
CREATE OPERATOR - (PROCEDURE = public."number_sub", LEFTARG = number, RIGHTARG = number);
CREATE OPERATOR - (PROCEDURE = public."number_uminus", RIGHTARG = number);
CREATE OPERATOR + (PROCEDURE = public."number_uplus", RIGHTARG = number);
