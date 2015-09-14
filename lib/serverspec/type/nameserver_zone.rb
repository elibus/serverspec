module Serverspec::Type
  class NameserverZone < Base

    def mx
      ret = @runner.run_command("dig +nosearch +short +time=1 -q #{@name} mx @8.8.8.8")
      ret.stdout.strip
    end

    def ns
      ret = @runner.run_command("dig +nosearch +short +time=1 -q #{@name} ns @8.8.8.8")
      ret.stdout.strip
    end

    def txt
      ret = @runner.run_command("dig +nosearch +short +time=1 -q #{@name} txt @8.8.8.8")
      ret.stdout.strip
    end

    def has_a?(query, record, ttl=nil)
      has_record?("-q #{query} A", record, ttl)
    end

    def has_aaaa?(query, record, ttl=nil)
      has_record?("-q #{query} AAAA", record, ttl)
    end

    def has_cname?(query, record, ttl=nil)
      has_record?("-q #{query} CNAME", record, ttl)
    end

    def has_ptr?(query, record, ttl=nil)
      has_record?("-x #{query}", record, ttl)
    end

    private
    def has_record?(query, record, ttl)
      ret = false

      output = @runner.run_command("dig +nosearch +noall +answer +time=1 #{query} @8.8.8.8").stdout.strip.split("\n")
      output.each { |result|
        result = result.split(/([a-zA-Z\.-_]+)\s+(\d+)\s+(\w+)\s+(\w+)\s+([a-zA-Z\.-_]+)/)
        actual_ttl = result[2].to_i
        actual_record = result[5].chomp(".")
        ret = true if actual_record.eql? record
        unless ttl.nil? then
          ret = ret && true if actual_ttl == ttl
        end
      }

      return ret
    end
  end
end
