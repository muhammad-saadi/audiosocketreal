# frozen_string_literal: true

PER_PAGE = 10
EMAIL_TEMPLATES = {
  approved: "<p>Hello [name]!</p><p>Thank you for submitting music to Audiosocket, we have listened to your music and would love to work with you. Congratulations and welcome!</p>
<p>Please sign up to our artist portal <a href=%{signup_path}>here</a> and review our artist agreement. We're happy to answer any questions you might have. There will also be a section to complete your W8/W9 details.</p>
<p>Please note, all co-writers and rights-holders (publishers, labels, etc) must sign off on the agreement. Please add them to the ‘Collaborators’ section.</p>
<p>Once you’ve accepted the agreement you can update your artist profile, submit music, artwork, promotional images, etc. The more assets you can give us the better we can feature you and your work.</p>
<p>Please remember to submit the instrumentals, stems, SFX & Sound Design if you have any. These are valuable to our clients and are often required for some placements. Once submitted, our team will review and will start the ingestion into our catalog.</p>
<p>Thank you and welcome to the Audiosocket family!</p>
<p>Vanessa<br>Music Licensing Coordinator<br>Audiosocket</p>",

  approved_exclusive_artist: "<p>Hi [name]!</p><p>Thanks for submitting music to Audiosocket, we have listened to your link and would love to work with you! You can check out some of our recent placements <a href='https://www.youtube.com/playlist?list=PL8474481F2967477D'>here</a>, it's a great time to come onboard.</p>
<p>We have two separate arms of our business, ASX (Audiosocket Exclusives) and Audiosocket. ASX focuses on high end Film/TV/Ad placements. It is a much smaller catalog, pitched in a very high touch way. Exclusivity is required at the highest end of sync licensing, it can be on a track level or an artist level. Exclusivity comes with additional benefits such as monthly payments, quarterly pitch updates, tracks coming up first insearch, additional marketing benefits and more.</p>
<p>Is this something you're interested in? Please sign up to our artist portal <a href=%{signup_path}>here</a> and review our exclusive artist agreement. We're happy to answer any questions you might have.</p>
<p>There will also be a section to complete your W8/W9 details. Please note all co-writers and rights-holders (publishers, labels, etc) must sign off on the agreement. So they have access to it, please add them to the 'Collaborators' section.</p>
<p>After this, you can update your artist profile, submit music, artworks, promo images, etc. The more assets you can give us the better. Please remember to submit the instrumentals, stems, SFX & SF if you have any. These are very valuable to our clients! Once submitted, our team will review and will start the ingestion into our catalog.</p><p>Thanks!</p><p>Vanessa<br>Music Licensing Coordinator<br>Audiosocket</p>",

  rejected: "<p>Hello [name],</p><p>Thank you for submitting an audition to Audiosocket. After careful review, we’ve decided the music you submitted is not a match for our current needs. Please understand, that while your music may not be a match this time, it certainly might be in the future as our clients’ needs are constantly changing. Please feel free to take a look at our recent placements as a reference for the types of music getting placed. With that in mind, we encourage you to submit new music again in the future.</p>
  <p>Thank you again for your consideration,</p>
  <p>Team Audiosocket<br></p>"
}.freeze
