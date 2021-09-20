# frozen_string_literal: true

PER_PAGE = 10
EMAIL_TEMPLATES = {
  approved: "<p>Hello [name]!</p><p>Thanks for submitting music to Audiosocket, we have listened to your links and would love to work with you!</p>
<p>Please sign up to our artist portal <a href=%{signup_path}>here</a> and review our artist agreement. We're happy to answer any questions you might have. There will also be a section to complete your W8/W9 details.</p>
<p>Please note, all co-writers and rights-holders (publishers, labels, etc) must sign off on the agreement. So they have access to it, please add them to the 'Collaborators' section.</p><p>After this, you can update your artist profile, submit music, artworks, promo images, etc. The more assets you can give us the better. Please remember to submit the instrumentals, stems, SFX & SF if you have any. These are very valuable to our clients! Once submitted, our team will review and will start the ingestion into our catalog.</p>
<p>You can check out some of our recent placements <a href='https://www.youtube.com/playlist?list=PL8474481F2967477D'>here</a>, it's a great time to come onboard. Please let us know if you have any questions.</p><p>Thanks!</p><p>Vanessa<br>Music Licensing Coordinator<br>Audiosocket</p>",

  approved_exclusive_artist: "<p>Hi [name]!</p><p>Thank you for submitting your music to Audiosocket. We have listened to your work and would love to work with you! Congratulations! It is a great time to come onboard as we’re working on a lot of exciting projects. You can check out some of our recent placements <a href='https://www.youtube.com/playlist?list=PL8474481F2967477D'>here</a>.</p>
<p>To help you better understand how we work, we have two separate arms of our business, ASX (Audiosocket Exclusives) and Audiosocket. ASX focuses on high end Film/TV/Ad placements. It is a much smaller catalog, pitched in a very high touch way. Exclusivity is required at the highest end of sync licensing, it can be on a track level or an artist level. Exclusivity comes with additional benefits such as monthly payments, bi-annual pitch reports, your tracks will come up first in search results, additional marketing benefits and more.</p>
<p>We’d like to offer you a spot on ASX. Please sign up to our artist portal <a href=%{signup_path}>here</a> and review our exclusive artist agreement. If you’d like to join this exclusive roster of amazing artists, please submit the agreement to get started. As well, we’re happy to answer any questions you might have.</p>
<p>There will also be a section to complete your W8/W9 details. Please note all co-writers and rights-holders (publishers, labels, etc) must sign off on the agreement. So they have access to it, please add them to the 'Collaborators' section.</p>
<p>After this, you can update your artist profile, submit music, artwork, promotional images, etc. The more assets you can give us the better we can feature you and your work. Please remember to submit the instrumentals, stems, SFX & Sound Design if you have any. These are valuable to our clients and are often required for high end placements. Once submitted, our team will review and will start the ingestion into our catalog.</p>
<p>Thank you and welcome to the Audiosocket family!</p><p>Vanessa<br>Music Licensing Coordinator<br>Audiosocket</p>",

  rejected: "<p>Hello!</p><p>We hope this note finds you safe and in good health. Thank you for submitting an audition to Audiosocket.</p>
  <p>After careful review, we've decided the music you submitted is not a good match for our current catalog at this time. Please understand, that while your music may not be a match this time, it certainly might be in the future, as our clients' needs are constantly changing. Please feel free to take a look at our recent placements as a reference for the types of music getting placed. With that in mind, we highly encourage you to submit new music again in the future.</p>
  <p>Thank you again,</p><p>Team Audiosocket<br></p>"
}.freeze
