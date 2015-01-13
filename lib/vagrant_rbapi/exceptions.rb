module VagrantRbapi
	class CommandReturnedNonZero < StandardError; end
	class BoxNotCreated < StandardError; end
	class BoxNotRunning < StandardError; end
	class BoxAlreadyRunning < StandardError; end
end
