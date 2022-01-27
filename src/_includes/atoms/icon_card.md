<a href="{{ include.url }}">
  <div class="bg-sc-gray-5 rounded-lg text-center h-32 flex justify-center items-center group transition hover:shadow-lg">
    <div>
      <div class="h-9 flex justify-center mb-3">
        {% if include.icon %}
          {% icon {{ include.icon }} %}
        {% endif %}
      </div>
      <span class="group-hover:text-sc-blue-1 ">{{ include.title }}</span>
    </div>
  </div>
</a>
