# Variables from bake.sh
variable "GIT_COMMIT_SHORT" {}

# Variables from .env file
variable "MAGENTO_USERNAME" {}
variable "MAGENTO_PASSWORD" {}
variable "MAGENTO_UID" {}

group "default" {
    targets = ["services"]
}

target "services" {
	/**
	 * Specify name resolution for targets that use a matrix strategy.
	 * https://docs.docker.com/build/bake/reference/#targetname
	 */
	name = item.service

    /**
	 * Define the matrix strategy.
	 * https://docs.docker.com/build/bake/reference/#targetmatrix
	 */
	matrix = {
		item = [
			{
				service = "nginx"
				args = {
					MAGENTO_USERNAME = "${MAGENTO_USERNAME}"
					MAGENTO_PASSWORD = "${MAGENTO_PASSWORD}"
					MAGENTO_UID = "${MAGENTO_UID}"
				}
			},
			{
				service = "php-fpm"
				args = {
					MAGENTO_USERNAME = "${MAGENTO_USERNAME}"
					MAGENTO_PASSWORD = "${MAGENTO_PASSWORD}"
					MAGENTO_UID = "${MAGENTO_UID}"
				}
			},
			{
				service = "cron"
				args = {
					MAGENTO_USERNAME = "${MAGENTO_USERNAME}"
					MAGENTO_PASSWORD = "${MAGENTO_PASSWORD}"
					MAGENTO_UID = "${MAGENTO_UID}"
				}
			},
			{
				service = "mariadb"
				args = {}
			},
			{
				service = "rabbitmq"
				args = {}
			},
			{
				service = "mailpit"
				args = {}
			}
		]
	}

    /**
	 * Specifies the location of the build context to use for this target
	 * https://docs.docker.com/build/bake/reference/#targetcontext
	 */
    context = item.service

    /**
	 * Name of the Dockerfile to use for the build.
	 * https://docs.docker.com/build/bake/reference/#targetdockerfile
	 */
    dockerfile = "Dockerfile"

    /**
	 * Image names and tags to use for the build target.
	 * https://docs.docker.com/build/bake/reference/#targettags
	 */
    tags = [
        "seasonofmist666/magento2:${item.service}",
        "seasonofmist666/magento2:${item.service}-${GIT_COMMIT_SHORT}",
    ]

    /**
	 * Define build arguments for the target.
	 * https://docs.docker.com/build/bake/reference/#targetargs
	 */
	args = item.args

    /**
	 * Set target platforms for the build target.
	 * https://docs.docker.com/build/bake/reference/#targetplatforms
	 */
	platforms = ["linux/amd64"]

	/**
	 * Don't use cache when building the image.
	 * https://docs.docker.com/build/bake/reference/#targetno-cache
	 */
	no-cache = false
}
