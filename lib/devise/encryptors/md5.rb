require 'digest/md5'

module Devise
  module Encryptable
    module Encryptors
      class Md5 < Base
        def self.digest(password, stretches, salt, pepper)
          Digest::MD5.hexdigest(password)
        end
      end
    end
  end
end
