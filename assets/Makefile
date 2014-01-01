CONFIGURE = @./tool/configure.sh
DEPLOY = @./tool/deploy.fragment.sh

build:
	$(CONFIGURE)
	@./tool/build.framework.sh
	@./tool/build.app.sh
	@./tool/compile.less.sh

config:
	$(CONFIGURE)

update-vendor:
	$(CONFIGURE)
	@./tool/update.vendor.sh

clean:
	@./tool/clean.sh

deploy:
	$(DEPLOY)

install:
	$(DEPLOY)
