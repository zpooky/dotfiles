#!/bin/bash

echo -e "# \e[1m\e[41m${1}\e[0m"

TYPE="[a-zA-Z_][a-zA-Z_0-9]*"
NAMESPACE=$TYPE
RETURN_TYPE=$TYPE
FUNCTION_NAME="[a-zA-Z_][a-zA-Z_0-9]*"
PARAMETERS="[a-zA-Z_0-9,*&: ]*"
VARIABLE_NAME=$TYPE
BLANK="[ \t]+"
OBLANK="[ \t]*"

OPARM_KW="(${OBLANK}const|${OBLANK}volatile)*"
A_PARAMETER="${OBLANK}${OPARM_KW}${OBLANK}(${NAMESPACE}::){0,1}${TYPE}${OBLANK}[*&]*${OBLANK}${OPARM_KW}${OBLANK}(${VARIABLE_NAME}){0,1}${OBLANK}"
PARAMETRS_R="\(((${A_PARAMETER})(,|\)))*"
echo ${PARAMETRS_R}


REG_MATCH="^[ \t]*${RETURN_TYPE}[ \t]+${FUNCTION_NAME}${PARAMETRS_R}[ \t]*;"
echo "regex: ${REG_MATCH}"

ack-grep "${REG_MATCH}" --cpp

# void Debug(const char* theCaller, const char* theMethod, const Guid& theFileID, const char* theFormat, ...);
# bool LoadFile( FILE*, TiXmlEncoding encoding = TIXML_DEFAULT_ENCODING );
# TiXmlHandle FirstChild( const std::string& _value ) const
# return append(&single, 1);
# return AddInterfaceFileValue(theName, value);



# inline extern virtual constexpr static const volatile *return_type* function(volatile const std::Name*& paramter,...) const nexecept except($TYPE,...) override;
# ... auto function(...) -> return ...
# ... function(void) ...
# ... functuion(arg1, ...) ...
# std::string const function(...)...
