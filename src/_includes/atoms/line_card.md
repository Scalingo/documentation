<a href="{{ include.url }}">
  <div class="bg-sc-gray-5 rounded-lg h-24 flex items-center px-5 border-l-4 border-sc-blue-1 group transform hover:border-l-8 duration-200 ease-out hover:shadow-lg">
    <div class="font-bold h-12 w-2/3 group-hover:text-sc-blue-1 transition text-sc-title-4-2 line-clamp-2">{{ include.title }}</div>
    <div class="font-bold h-12 w-1/3 flex items-end justify-end">
      <div class="transform group-hover:translate-x-1 duration-200 ease-out">{% icon arrow_right %}</div>
    </div>
  </div>
</a>
