# frozen_string_literal: true

PER_PAGE = 10
EMAIL_TEMPLATES = {
  approved: "<p>Hello!<br>We hope this note finds you safe and in good health. Thank you for submitting an audition to Audiosocket.</p>
  <p>Hello [name]!<br>Thanks for submitting music to Audiosocket, we have listened to your links and would love to work with you!</p>
  <p>I've attached our artist agreement here. Please note, all co-writers and rights-holders must sign off on the agreement. Please review it and let me know if you have any questions. Next steps after signing will be submitting music, instructions to follow.</p>
  <p>Attached is also the W9, which will need to match with the bank account payee given on your agreement. If you're outside of the USA, we can make payments via Paypal. In this case, we'd need your Paypal address and a W8 filled out.</p>
  <p>You can check out some of our recent placements here, it's a great time to come onboard. Please let us know if you have any questions.</p>
  <p>Thanks!<br>Vanessa<br>Music Licensing Coordinator<br>Audiosocket</p>",

  approved_exclusive_artist: "<p>Hi [name]!</p>Thanks for submitting music to Audiosocket, we have listened to your link and would love to work with you! You can check out some of our recent placements here, it's a great time to come onboard.</p>
  <p>We have two separate arms of our business, ASX (Audiosocket Exclusives) and Audiosocket. ASX focuses on high end Film/TV/Ad placements. It is a much smaller catalog, pitched in a very high touch way. Exclusivity is required at the highest end of sync licensing, it can be on a track level or an artist level. Exclusivity comes with additional benefits such as monthly payments, quarterly pitch updates, tracks coming up first insearch, additional marketing benefits and more.</p>
  <p>Is this something you're interested in? Please let us know and then we can send along some additional information.</p>
  <p>Thanks!</p><br>Vanessa",

  rejected: "<p>Hello!<br>We hope this note finds you safe and in good health. Thank you for submitting an audition to Audiosocket.</p>
  <p>After careful review, we've decided the music you submitted is not a good match for our current catalog at this time. Please understand, that while your music may not be a match this time, it certainly might be in the future, as our clients' needs are constantly changing. Please feel free to take a look at our recent placements as a reference for the types of music getting placed. With that in mind, we highly encourage you to submit new music again in the future.</p>
  <p>Thank you again,<br>Team Audiosocket<br></p>"
}.freeze
