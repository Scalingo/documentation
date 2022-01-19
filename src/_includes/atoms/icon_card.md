<a href="{{ include.url }}">
  <div class="bg-sc-gray-5 rounded text-center h-32 flex justify-center items-center">
    <div>
      <div class="h-9 flex justify-center mb-3">
        {% if include.icon %}
          {% icon {{ include.icon }} %}
        {% endif %}
      </div>
      <span class="text-sc-gray-2 font-bold">{{ include.title }}</span>
    </div>
  </div>
</a>
