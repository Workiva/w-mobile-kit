Description
---


What Was Changed
---


Acceptance Criteria
---


Testing Instructions
---


Merge Checklist
---
- [ ] Author of commit is not a reviewer
- [ ] CR +1
- [ ] QA +1 (includes code review and pulling in the code/testing)
- [ ] bundle exec pod lib lint WMobileKit.podspec --allow-warnings passes
- [ ] Security review if applicable
- [ ] Bump the WMobileKit.podspec, Source/Info.plist, and Example/WMobileKitExample/Info.plist
using ```version_bump.sh```according to semantic versioning.

Example: (5.1.0 is the old version 5.1.1 is the new version)
```ruby
./version_bump.sh 5.1.0 5.1.1
```

---
Please Review: @Workiva/mobile  
