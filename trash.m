@import Foundation;

int main(int argc, const char *argv[]) {
	@autoreleasepool {
		// Revert back to original user if sudo,
		// ensuring the file is put in the users trash
		const char *sudo_uid = getenv("SUDO_UID");
		if (sudo_uid) {
			setuid((uid_t)atoi(sudo_uid));
		}

		if (argc == 1) {
			fputs("Specify one or more paths\n", stderr);
			return 1;
		}

		NSArray *args = [NSProcessInfo processInfo].arguments;

		if ([args[1] isEqualToString: @"--version"]) {
			puts("trash version 1.1.0");
			return 0;
		}

		if ([args[1] isEqualToString: @"--help"]) {
			puts("Usage: trash <path> [...]");
			return 0;
		}

		NSFileManager *fm = [NSFileManager defaultManager];
		NSError *err;

		for (int i = 1; i < argc; i++) {
			NSURL *url = [NSURL fileURLWithPath:@(argv[i])];

			if (![fm trashItemAtURL:url resultingItemURL:nil error:&err]) {
				fprintf(stderr, "%s\n", err.localizedDescription.UTF8String);
				return 1;
			}
		}
	}

	return 0;
}
