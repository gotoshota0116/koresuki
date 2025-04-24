module PagyHelper
	def custom_pagy_nav(pagy, id: nil, aria_label: nil, **vars)
		id = %( id="#{id}") if id
		a = pagy_anchor(pagy, **vars)
  
		html = %(<nav#{id} class="pagy nav" #{nav_aria_label(pagy, aria_label:)}>#{prev_a(pagy, a)})
		pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
		  html << case item
				  when Integer
					%(<a href="#{a.(item).match(/href="([^"]*)/)[1]}" data-action="click->loading#show">#{item}</a>)
				  when String
					%(<a role="link" aria-disabled="true" aria-current="page" class="current">#{pagy.label_for(item)}</a>)
				  when :gap
					%(<a role="link" aria-disabled="true" class="gap">#{pagy_t('pagy.gap')}</a>)
				  else
					raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
				  end
		end
		html << %(#{next_a(pagy, a)}</nav>)
	end
  
	# Similar to I18n.t: just ~18x faster using ~10x less memory
	# (@pagy_locale explicitly initialized in order to avoid warning)
	def pagy_t(key, **opts)
		Pagy::I18n.translate(@pagy_locale ||= nil, key, **opts)
	end
  
	private
  
	def nav_aria_label(pagy, aria_label: nil)
		aria_label ||= pagy_t('pagy.aria_label.nav', count: pagy.pages)
		%(aria-label="#{aria_label}")
	end
  
	def prev_a(pagy, a, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'))
		if (p_prev = pagy.prev)
		  href = a.(p_prev, text, aria_label:).match(/href="([^"]*)/)[1]
		  %(<a href="#{href}" data-action="click->loading#show" aria-label="#{aria_label}">#{text}</a>)
		else
		  %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
		end
	end
  
	def next_a(pagy, a, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'))
		if (p_next = pagy.next)
		  href = a.(p_next, text, aria_label:).match(/href="([^"]*)/)[1]
		  %(<a href="#{href}" data-action="click->loading#show" aria-label="#{aria_label}">#{text}</a>)
		else
		  %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
		end
	end
end
	