module Assembly
  module Util
    def self.underscore(str)
      str.scan(/[A-Z][a-z]*/).join("_").downcase
    end

    def self.models
      {
        academic_year: AcademicYear,
        aspect: Aspect,
        assessment_point: AssessmentPoint,
        assessment: Assessment,
        attendance: Attendance,
        calendar_event: CalendarEvent,
        contact: Contact,
        exclusion: Exclusion,
        facet: Facet,
        grade_set: GradeSet,
        grade: Grade,
        list: List,
        registration_group: RegistrationGroup,
        result: Result,
        school_detail: SchoolDetail,
        staff_member: StaffMember,
        student: Student,
        subject: Subject,
        teaching_group: TeachingGroup,
        year_group: YearGroup
      }
    end

    def self.build(response, client=nil)
      case response
      when Hash
        klass = response.has_key?(:object) ? models.fetch(response[:object].to_sym, ApiModel) : Model
        klass.construct_from(response, client)
      when Array
        response.map {|o| Util.build(o, client) }
      else
        response
      end
    end
  end
end
