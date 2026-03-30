local logger = {}

logger.LOG_LEVEL = {
	SPAM = 1,
	TRACE = 2,
	DEBUG = 3,
	WARN = 4,
	INFO = 5,
	FATAL = 6,
}

local LEVEL_TO_LOG = { "SPAM", "TRACE", "DEBUG", "WARN", "INFO", "FATAL" }

logger.guard = function(message: string, name: string?, ...): ()
	local name_text = name and `[{name}] ->` or "->"
	print(`[GUARD] {name_text} {message}`, ...)
	return 
end

logger.log = function(level: number, message: string, name: string?): ()
	--if Configurations.Enviroment.Production then
	--	return
	--end 
		
	local logLevel = 1 or logger.LOG_LEVEL.WARN
	
	if level < logLevel then
		return
	end
	
	local name_text = name and `[{name}] ->` or "->"
	local text = `[{LEVEL_TO_LOG[level]}] {name_text} {message}`
	
	if level == logger.LOG_LEVEL.WARN then
		warn(text)
		return
	end
	
	print(text)
end

logger.spam = function(message: string, name: string?): ()
	return logger.log(1, message, name)
end

logger.trace = function(message: string, name: string?): ()
	return logger.log(2, message, name)
end

logger.debug = function(message: string, name: string?): ()
	return logger.log(3, message, name)
end

logger.warn = function(message: string, name: string?): ()
	return logger.log(4, message, name)
end

logger.info = function(message: string, name: string?): ()
	return logger.log(5, message, name)
end

logger.child = function(name: string)
	return {
		guard = function(message: string, ...): ()
			return logger.guard(message, name, ...)
		end,
		
		guard_nil = function(message: string, ...): nil
			logger.guard(message, name, ...)
			return nil
		end,
		
		spam = function(message: string): ()
			return logger.spam(message, name)
		end,
		trace = function(message: string): ()
			return logger.trace(message, name)
		end,
		debug = function(message: string): ()
			return logger.debug(message, name)
		end,
		warn = function(message: string): ()
			return logger.warn(message, name)
		end,
		info = function(message: string): ()
			return logger.info(message, name)
		end,
	}
end

return logger
