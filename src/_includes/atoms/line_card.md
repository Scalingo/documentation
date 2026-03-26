<a href="{{ include.url }}">
  <div class="bg-sc-gray-5 rounded-lg h-24 flex items-center px-5 border-l-8 border-primary-orange-300 group transform hover:border-l-12 duration-200 ease-out hover:shadow-lg">
    <div class="font-bold h-12 w-2/3 group-hover:text-primary-orange-400 transition text-sc-title-4-2 line-clamp-2">{{ include.title }}</div>
    <div class="font-bold h-12 w-1/3 flex items-end justify-end">
      <div class="transform group-hover:translate-x-1 duration-200 ease-out text-primary-orange-400">{% icon arrow_right %}</div>
    </div>
  </div>
</a>
