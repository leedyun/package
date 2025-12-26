module ApplicantTracking
	class Jobs < Resource
		class Applications < Resource
			self.prefix = "/remote/jobs/:job_id/"
		end

		def initialize(attributes = {}, persisted = false)
			# Server implements "find" functionality by
			# returning a one-element array, which active
			# resource does not like. Therefore, when
			# given an array, must use the first element.
			attributes = attributes[0] if attributes.is_a?(Array)
			super(attributes, persisted)
		end

		def applications(params = {})
			# get my applications
			my_id = self.id.to_s
			Class.new(ApplicantTracking::Applications) do
				def self.name
					superclass.to_s
				end

				def create
					@is_creating = true
					super()
				ensure
					@is_creating = false
				end

				def load(attributes, remove_root = false, persisted = false)
					# AT API does not return a
					# hash as AR expects, so
					# circumvent this method when
					# creating a new application.
					if(! @is_creating)
						super(attributes, remove_root, persisted)
					end
				end

				def update
					run_callbacks :update do
						connection.post(element_path(prefix_options), encode, self.class.headers)
					end
				end

				self.prefix = "/remote/jobs/#{my_id}/"
			end
		end
	end
end
