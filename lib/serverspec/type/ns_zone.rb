module Serverspec::Type
  class NameServerZone < Base

    def mx
      ret = @runner.run_command("dig +search +short +time=1 -q #{escape(@name)} a @127.0.0.1")
      ret.stdout.strip
    end

    def ns
      ret = @runner.run_command("dig +search +short +time=1 -q #{escape(@name)} ns @127.0.0.1")
      ret.stdout.strip
    end

    def has_record?(type, query, result)
      #inspection['Volumes'][container_path] == host_path
    end
  end
end
