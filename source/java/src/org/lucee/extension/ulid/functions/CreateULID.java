/**
 *
 * Copyright (c) 2014, the Railo Company Ltd. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either 
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 **/

package org.lucee.extension.ulid.functions;

import com.github.f4b6a3.ulid.UlidCreator;

import lucee.runtime.PageContext;
import org.lucee.extension.ulid.functions.FunctionSupport;
import lucee.runtime.exp.PageException;

/**
 * Implements the CFML Function createulid
 */
public class CreateULID extends FunctionSupport {

	/**
	 * method to invoke the function
	 * 
	 * @param pc
	 * @return ULID String
	 */
	public static String call(PageContext pc) throws PageException {
		return UlidCreator.getUlid().toString();
	}

	public static String call(PageContext pc, String type) throws PageException {
		if ("monotonic".equalsIgnoreCase(type)) return UlidCreator.getMonotonicUlid().toString();
		else if ("".equalsIgnoreCase(type)) return UlidCreator.getUlid().toString();
		else throw exp.createExpressionException("invalid ULID type [" + type + "]," + " valid values are [monotonic,hash]");
	}

	public static String call(PageContext pc, String type, long input1, String input2) throws PageException {
		if ("hash".equalsIgnoreCase(type)) return UlidCreator.getHashUlid( input1, input2 ).toString();
		else throw exp.createExpressionException("invalid ULID type [" + type + "]," + " valid values are [monotonic,hash]");
	}

	
	/*
	public Object invoke(PageContext pc, Object[] args) throws PageException {
		if(args.length==4) return call(pc, args[0],cast.toDoubleValue(args[1]),cast.toString(args[2]),cast.toString(args[3]));
		if(args.length==3) return call(pc, args[0],cast.toDoubleValue(args[1]),cast.toString(args[2]));
		if(args.length==2) return call(pc, args[0],cast.toDoubleValue(args[1]));
		throw exp.createFunctionException(pc, "ImageShear", 2, 4, args.length);
	}
	*/
	@Override
	public Object invoke(PageContext pc, Object[] args) throws PageException {
		if (args.length == 0) return call(pc);
		else if (args.length == 1) return call(pc, cast.toString(args[0]));
		else if (args.length == 3) return call(pc, cast.toString(args[0]), cast.toLong(args[1]), cast.toString(args[2]) );
		else throw exp.createFunctionException(pc, "createULID", 2, 5, args.length);
		// else throw exp.createFunctionException("invalid ULID type [" + cast.toString(args[0]) + "]," + " valid values are [monotonic,hash]");
	}
}