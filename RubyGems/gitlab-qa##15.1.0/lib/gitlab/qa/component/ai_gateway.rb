# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class AiGateway < Base
        DOCKER_IMAGE = 'registry.gitlab.com/gitlab-org/modelops/applied-ml/code-suggestions/ai-assist/model-gateway'
        DOCKER_IMAGE_TAG = 'latest'

        LOG_FILE_NAME = 'modelgateway_debug.log'

        # Test signing key to enable direct connection code completions
        # https://gitlab.com/gitlab-org/modelops/applied-ml/code-suggestions/ai-assist/-/blob/97f54f4b7e43258a39bba7f29f38fe44bd316ce5/example.env#L79
        TEST_SIGNING_KEY =
          <<~SIGNING_KEY
            -----BEGIN PRIVATE KEY-----
            MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQD35X6SQq7VuIV8
            jRNta9yfQJzVLqfYOFwSqismmvR1/2y/pO7HWsXo1HhkQdzF7U1zJLh8b0PiSkDE
            dpUzkt5b4mPIit7khx7/wMi+t+gi1dpP+gTXxqOB8A/UzvQxBEKhizoGw/hG7vzT
            MYqJRO1xHCYsMNU2TfWuoGR/7RXIidXzXmEShZ6bFeEWqupV7D0X6n8WVMd+NrZZ
            lCNP0O67kCZGpABHcQ/uDUcRhyHYFkGHoSwp7KS2416PXMiRs01VRUG7fnOkgo4C
            zyPWfuzSMjkKPm9gr9P0qYGsNrOBmV0guyLg4JWcVhDvkuh32r/kHrwxwUDYSLyI
            GfAKKmZDAgMBAAECggEAKLfCEdVw0PCywayNKQdIgRf51W0JFhOGfBewvXHs/ty/
            nhLsmEN+sn8DxLlUwWX4YhYBVN8UcBJGOn7yhDrML0eA9asUcBu0VHSer0TslPGP
            dFzazXPL3kdHh8BJN9aSozoyg8ijT/NoBRXkGCasNvdVWyOCQfM4NutoK+MOFZbL
            krtGPWfjTPByaZnV1PDJq95wz6LQeSdNwZLABE4YIrBxg0V1zu1gb0paltHZjPaM
            68rm6Hp78CqI/5v9/RqQaso8aYVdjBaEkEI40CgKZY8Jm04NE4EcQM4Z4IYFc8I/
            Ewj0giQIkZrGuucOA9S8TNqDjerv+8NoLMRCRcTk8QKBgQD9nHZGdW+2+IjShTal
            EzjHH37APQKXYi0R9IESdzRnkUrL/8Rnxe5f7VxmDXJys0+IGo+8JoqGRUWJD8WZ
            oBNW8oqJ4OH/dH07v2W0a0L0Z0Fcq6lv6tFcq1inSLPlk6EW3h4vTlrknuQ6QaKq
            74SksBB4dCGDLlOaL8jldg9YVwKBgQD6O0CciiL3xVdnx4cGHDEjs9UU10z0EeVs
            0gNxdAdkQEdgj9wI1yzNywFXtI+UA26j7207vYcU0hQ029roJN5ogTOkcCuf9WPQ
            RV/+BQhiEJGYmZF8KlWiCB1HTxvc3p04EmIsp1N6yuqoE0jUFIS3A4GYYHPDZwDa
            G8Y+W68d9QKBgQC7aFxqcqusDPqmfrRDxfGGC7sRecQpc+4UP5cFuzrpcY9RMl7D
            xJsDHhbSfwtcwS57SA2BHwXsdNIOl64QeR7xeGdxvdGjgURt22DfsweWLZs6TMv3
            nRE7Jo9rhqkRdEds65RopsE6AkRq3EfFgxuEy2pQaJi/JIO5A6i0D8sFHwKBgQCI
            rtDuMO5E1QCXaX+xsLiOve5IggpAz324YUcMM8rN0earMimIkrCggKDtHW3H9c/7
            sA7EsRQWJWJwNR9v6qOqBdkFm1fY+htZamuyv2EC3/YHmurDHgTEixYjG20mylqq
            hDAoIAYTbr+aq13+qm6L4VhquVTCiYMHoGA7M62F+QKBgQCfTv5XVu+bEEBKyTkf
            oVWjaLbO99zrgRYmZ9zhiRtlYFKefQ4kKxr+SRcia2dxQiNVPh5qUkX6ukvgCEVl
            GoFTlopsX/CbilNarkwa/nvgQQeZAlrFpONifrtfZffV2Cs6wcwYAL8W5qFtl6iy
            ZpLGJZdEWAPTxB6ppnDC75/KOg==
            -----END PRIVATE KEY-----
          SIGNING_KEY

        # Test validation key to enable direct connection code completions
        # https://gitlab.com/gitlab-org/modelops/applied-ml/code-suggestions/ai-assist/-/blob/97f54f4b7e43258a39bba7f29f38fe44bd316ce5/example.env#L79
        TEST_VALIDATION_KEY =
          <<~VALIDATION_KEY
            -----BEGIN PRIVATE KEY-----
            MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOAJNEB8EoyCAk
            acSevXg5md0/JJGxBrHpIHqDuSf5FEENU0eGCc3PLZh5IjFcijGThMy0r/OMQn/n
            /KAVCLlyPBaLEGsxqXJcW2CmNM24A3zyR4b7ghB+POKJY9lD2JoUWe57+B0IgZuz
            PQbwRvuO7ULsw4xgGoLcoiscYMzKEWuFKDrteim+2vjCif5DDohKZQc3Ic8dwOtL
            2C6+dV2TdyK0JPD7Kc1ONnH3S/VWJ8W5DDO1q5MrwJ+CQMaofHRqpbZrc66i5v2y
            6/ooB0W14D1Qy4GmMIkLnkdP9UcYRHL7cVDv0D+bHs0xIyTXgbZaL78VFUyqeq23
            qR4opOmFAgMBAAECggEABiJ5lZFkN4ew1VoaUzPclwfgUSy7SKSkuwbkPx9OHm/I
            +XxHvqkfaj0MXlxzUIiDrhtKpqgwE4w4wjrWtZRQmXif9JI6RFIB0thHH4v7rbAv
            kgjT7zzSAEBl6qYrkTFWcqa0Sxgkx90RkEaP+gB90KV7fxDaZv5DHrjsRGhpkNbi
            8qtJOrvY6we6nx/YaD3iK69qQk6ktRg1AYUDH3xjBIIzo6brqlL2NJ+Q4VerrHFU
            2EhTXto+4Y51Qjpas5B7DHmEhghZtYsMceuqFNvDQgGg1IsBPB4icTIREzHJ0rj3
            Xgh5DMJGYb0p7Ktm74jciTdFIHeDMUCLoxxSPTZavQKBgQDs1njL0VR1hZKiGihO
            fP0L3BwNL0H6uqKOlPP+DwdnNv7Q99xMKe9qcGWeiFXrLDkVMkd0M2LfU4SH5XUO
            mt0YSC7Fn/pwozbk61k9+oEnL9cwDpwFwr46ccY6hmp3iihLTrgDuAi0CMSurZrC
            mnqOOAxuSq6D7a/yhNKdEvckqwKBgQDeq2tIXlWVPXBY6CgIhUakq0oqHn35lhx4
            CJuc1cujm1C68/UiZvxRK1LLAcFlDLl7+lnCSKnNn6fwK+jCsEsGT8ZuCJ2FznGH
            wN6B3qrgEsB+FgC6qLir/o83E8I0tSOITaWHHvIc/l1PuXHJbwfCd2yB1sdeshID
            x9o38/pKjwKBgH1YQRQ11IpiSCnMyDpKAi7Nrnb35OaK8k+d28hBMfzZaWE1XP1e
            UFy34cBWjYpqnEdwlcqVC6YAcKrvsNUq9wrL4R0svwHwD7R2LoQT2VjhA/VmNgMC
            f2U1I+GDlENx9kNtBQzK0Khf36BHNxn5YhV06ndQxS4DlNQ4obMJ/40DAoGBAIWm
            DfaZ6HRzNAOpFJ5IoGYmCZXOR36PAvdo8z3ndRr2FjagRvonJjrx7fe7TgEA6jPn
            yAg85O5ubbZSJJr2hZF8QHW65hFyH+KDeQoqRBXKK4+CVV2z92QEnqFIUsCgGHuv
            XzMC9/8/DXLUs99brSSj2ZT0/SVxbC6ovennnssxAoGALtm2AUBMgsU6b9B+Fp2L
            ZBQSwkyd3bOD7sFJHhbmiRE/ag2lsaE+dNg9H42fhOV0MXfPkEBWCIaGt931T5+q
            FVATlTTDAx2CRmJCOyXkQ6mGBFTkQPqDwmWvwjbK9B5r0SnGfCpk4uEYWoYYsX05
            t14Huwf9VVUTCfEi0+wWcko=
            -----END PRIVATE KEY-----
          VALIDATION_KEY

        def initialize
          super

          # These keys are test keys and are safe to be shared, but masking them in logs so they do not raise concern
          @secrets << TEST_SIGNING_KEY
          @secrets << TEST_VALIDATION_KEY
        end

        def name
          @name ||= 'ai-gateway'
        end

        def host_log_path
          File.join(Runtime::Env.host_artifacts_dir, name, 'logs', LOG_FILE_NAME)
        end

        def container_log_path
          File.join('home', 'aigateway', 'app', LOG_FILE_NAME)
        end

        def configure_environment(gitlab_hostname:)
          @environment = {
            'AIGW_GITLAB_URL' => "http://#{gitlab_hostname}",
            'AIGW_GITLAB_API_URL' => "http://#{gitlab_hostname}/api/v4",
            'AIGW_CUSTOMER_PORTAL_URL' => Runtime::Env.customer_portal_url,
            'AIGW_MOCK_MODEL_RESPONSES' => true,
            'AIGW_LOGGING__LEVEL' => 'debug',
            'AIGW_LOGGING__TO_FILE' => LOG_FILE_NAME,
            'AIGW_SELF_SIGNED_JWT__SIGNING_KEY' => TEST_SIGNING_KEY,
            'AIGW_SELF_SIGNED_JWT__VALIDATION_KEY' => TEST_VALIDATION_KEY,
            'CLOUD_CONNECTOR_SERVICE_NAME' => 'gitlab-ai-gateway'
          }
        end

        def teardown
          # Copy debug log file to host artifacts directory
          begin
            Docker::Command.execute(
              "cp #{name}:#{container_log_path} #{host_log_path}"
            )
          rescue Support::ShellCommand::StatusError => e
            Runtime::Logger.warn(
              "Unable to copy log file from #{name}: #{e.message}"
            )
          end

          super
        end
      end
    end
  end
end
