
component initmethod="EntityDump" {

	function EntityDump(any object) {
		instance.entity = object;
		return this;
	}

	function dump() {

		if(IsArray(instance.entity)) {
			dumpArray();
		} else {
			dumpObject();
		}
	}

	private function dumpArray() {
		var local = {};
		var entityArray = [];
		for(local.count = 1; local.count <= ArrayLen(instance.entity); local.count++) {
			arrayAppend(entityArray, outputObject(instance.entity[local.count]));
		}
		writeDump(entityArray);
	}

	private function dumpObject() {
		writeDump(outputObject(instance.entity));
	}

	private struct function outputObject(required any object) {
		var md = getMetaData(object);
		var entityStruct = {};

		if(not structKeyExists(md, 'persistent')) {
			throw (
				message = "trying to dump a non entity object",
				detail = "");
		}
		entityStruct = filterProperties(md.properties, object);
		return entityStruct;
	}

	private struct function filterProperties(required array data, required any object) {
		var retStruct = {};
		var propertyValue = '';
		retStruct.properties = {};
		for(var count = 1; local.count <= ArrayLen(arguments.data); local.count++) {
			if(structKeyExists(arguments.data[count], 'lazy')) {
				propertyValue = 'Object not loaded';
			} else {
				propertyValue = evaluate("arguments.object.get#arguments.data[count].name#()");
			}
			if(isNull(propertyValue)) {
				propertyValue = '';
			}
			retStruct.properties[arguments.data[count].name] = propertyValue;
		}
		return retStruct;
	}

}
