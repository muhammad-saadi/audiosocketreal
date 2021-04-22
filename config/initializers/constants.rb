# frozen_string_literal: true

PER_PAGE = 10
EMAIL_TEMPLATES = {
  accepted: "<p>Hello [name]!</p><p>Thanks for submitting music to Audiosocket, we listened to your link and would love to work with you!</p>
  <p>I've attached our artist agreement here. Please note, all co-writers and rights-holders must sign off on the agreement. Please review it and let me know if you have any questions. Next steps after signing will be submitting music, instructions to follow.</p>
  <p>Attached is also the W9, which will need to match with the bank account payee given on your agreement. If you're outside of the USA, we can make payments via Paypal. In this case, we'd need your Paypal address and a W8 filled out.</p>
  <p?You can check out some of our recent placements here,it's a great time to come onboard.Please let us know if you have any questions.</p>Thanks!Vanessa",

  accepted_exclusive_artist: "<p>Hi [name]!</p>Thanks for submitting music to Audiosocket, we have listened to your link and would love to work with you! You can check out some of our recent placements here, it's a great time to come onboard.</p>
  <p>We have two separate arms of our business, ASX (Audiosocket Exclusives) and Audiosocket. ASX focuses on high end Film/TV/Ad placements. It is a much smaller catalog, pitched in a very high touch way. Exclusivity is required at the highest end of sync licensing, it can be on a track level or an artist level. Exclusivity comes with additional benefits such as monthly payments, quarterly pitch updates, tracks coming up first insearch, additional marketing benefits and more.</p>
  <p>Is this something you're interested in? Please let us know and then we can send along some additional information.</p>
  <p>Thanks!</p>Vanessa",

  rejected: "<p>Hello!</p><p>We hope this note finds you in safety and good health. We wanted to reach out to you about your Audiosocket audition that you had submitted. Please allow us to extend our deepest apologies for the length of time it took for us to get back to you. Our team members carefully review each and every submission that comes through, and we've been working tirelessly to get caught back up in the midst of the COVID-19 pandemic and the challenges that have come with it.</p>
    <p>After careful review, we've decided the music you submitted isn't a good match for our catalog at this time. Please understand, that while your music may not be a match this time, it certainly might be in the future, as our clients needs are constantly changing. Please feel free to take alook at our recent placements as a reference for the types of music getting placed. With that in mind, we highly encourage you to submit new music again in the future.</p>
    Thank you again,<br>Team Audiosocket"
}.freeze
