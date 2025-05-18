/*-------------------------------------------------------------------------
 *
 * pg_numbertype
 *	  A simple NUMBER implementation for demonstration purposes.
 *
 * Copyright (c) 2025, William Ivanski
 *
 *-------------------------------------------------------------------------
 */


#include "postgres.h"
#include "fmgr.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>



PG_MODULE_MAGIC;


/*
 * Number -
 *
 *  Internal representation for number data type
 */
typedef struct Number {
    double      x;
} Number;


/*
 * number_in() -
 *
 *	Input function for number data type
 */
PG_FUNCTION_INFO_V1(number_in);
Datum
number_in(PG_FUNCTION_ARGS)
{
	char	   *str = PG_GETARG_CSTRING(0);
	double      x;
	Number     *result;

	if (sscanf(str, "%lf", &x) != 1)
		ereport(ERROR,
			    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
			     errmsg("invalid input syntax for type NUMBER: \"%s\"",
			    	    str)));

    result = (Number *) palloc(sizeof(Number));

    result->x = x;

    PG_RETURN_POINTER(result);
}


/*
 * number_out() -
 *
 *	Output function for number data type
 */
PG_FUNCTION_INFO_V1(number_out);
Datum
number_out(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
    char       *result;
    int         last;
    
    result = psprintf("%.8lf", num->x);

    /* If there's no decimal point, there's certainly nothing to remove. */
	if (strchr(result, '.') != NULL)
	{
		/*
		 * Back up over trailing fractional zeroes.  Since there is a decimal
		 * point, this loop will terminate safely.
		 */
		last = strlen(result) - 1;
		while (result[last] == '0')
			last--;

		/* We want to get rid of the decimal point too, if it's now last. */
		if (result[last] == '.')
			last--;

		/* Delete whatever we backed up over. */
		result[last + 1] = '\0';
	}

    PG_RETURN_CSTRING(result);
}


/*
 * number_smallint() -
 *
 *	Converts from number to smallint
 */
PG_FUNCTION_INFO_V1(number_smallint);
Datum
number_smallint(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
	int16      result;

	result = (int16) round(num->x);

    PG_RETURN_INT16(result);
}


/*
 * number_integer() -
 *
 *	Converts from number to integer
 */
PG_FUNCTION_INFO_V1(number_integer);
Datum
number_integer(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
	int32      result;

	result = (int32) round(num->x);

    PG_RETURN_INT32(result);
}


/*
 * number_bigint() -
 *
 *	Converts from number to bigint
 */
PG_FUNCTION_INFO_V1(number_bigint);
Datum
number_bigint(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
	int64      result;

	result = (int64) round(num->x);

    PG_RETURN_INT64(result);
}


/*
 * number_abs() -
 *
 *	Absolute operator (@) for number data type
 */
PG_FUNCTION_INFO_V1(number_abs);
Datum
number_abs(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	if (num->x >= 0.0)
    	result->x = num->x;
   	else
   		result->x = -1.0 * num->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_uminus() -
 *
 *	Unary minus operator (-) for number data type
 */
PG_FUNCTION_INFO_V1(number_uminus);
Datum
number_uminus(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = -1.0 * num->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_uplus() -
 *
 *	Unary plus operator (+) for number data type
 */
PG_FUNCTION_INFO_V1(number_uplus);
Datum
number_uplus(PG_FUNCTION_ARGS)
{
	Number     *num = (Number *) PG_GETARG_POINTER(0);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = num->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_add() -
 *
 *	Addition operator (+) for number data type
 */
PG_FUNCTION_INFO_V1(number_add);
Datum
number_add(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = num1->x + num2->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_sub() -
 *
 *	Subtraction operator (-) for number data type
 */
PG_FUNCTION_INFO_V1(number_sub);
Datum
number_sub(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = num1->x - num2->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_mul() -
 *
 *	Multiplication operator (*) for number data type
 */
PG_FUNCTION_INFO_V1(number_mul);
Datum
number_mul(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = num1->x * num2->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_div() -
 *
 *	Division operator (/) for number data type
 */
PG_FUNCTION_INFO_V1(number_div);
Datum
number_div(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = num1->x / num2->x;

    PG_RETURN_POINTER(result);
}


/*
 * number_mod() -
 *
 *	Modulo operator (%) for number data type
 */
PG_FUNCTION_INFO_V1(number_mod);
Datum
number_mod(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = fmod(num1->x, num2->x);

    PG_RETURN_POINTER(result);
}


/*
 * number_power() -
 *
 *	Power operator (^) for number data type
 */
PG_FUNCTION_INFO_V1(number_power);
Datum
number_power(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	Number     *result;
	
	result = (Number *) palloc(sizeof(Number));

	result->x = pow(num1->x, num2->x);

    PG_RETURN_POINTER(result);
}


/*
 * number_eq() -
 *
 *	Equal operator (=) for number data type
 */
PG_FUNCTION_INFO_V1(number_eq);
Datum
number_eq(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	bool       result;

	result = num1->x == num2->x;
	
	PG_RETURN_BOOL(result);
}


/*
 * number_ne() -
 *
 *	Not equal operator (<>) for number data type
 */
PG_FUNCTION_INFO_V1(number_ne);
Datum
number_ne(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	bool       result;

	result = num1->x != num2->x;
	
	PG_RETURN_BOOL(result);
}


/*
 * number_gt() -
 *
 *	Greater than operator (>) for number data type
 */
PG_FUNCTION_INFO_V1(number_gt);
Datum
number_gt(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	bool       result;

	result = num1->x > num2->x;
	
	PG_RETURN_BOOL(result);
}


/*
 * number_lt() -
 *
 *	Lesser than operator (<) for number data type
 */
PG_FUNCTION_INFO_V1(number_lt);
Datum
number_lt(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	bool       result;

	result = num1->x < num2->x;
	
	PG_RETURN_BOOL(result);
}


/*
 * number_ge() -
 *
 *	Greater than or equal operator (>=) for number data type
 */
PG_FUNCTION_INFO_V1(number_ge);
Datum
number_ge(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	bool       result;

	result = num1->x >= num2->x;
	
	PG_RETURN_BOOL(result);
}


/*
 * number_le() -
 *
 *	Lesser than or equal operator (<=) for number data type
 */
PG_FUNCTION_INFO_V1(number_le);
Datum
number_le(PG_FUNCTION_ARGS)
{
	Number     *num1 = (Number *) PG_GETARG_POINTER(0);
	Number     *num2 = (Number *) PG_GETARG_POINTER(1);
	bool       result;

	result = num1->x <= num2->x;
	
	PG_RETURN_BOOL(result);
}
