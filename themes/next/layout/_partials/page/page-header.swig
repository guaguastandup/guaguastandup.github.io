<header class="post-header">

<h1 class="post-title" itemprop="name headline">
  {{- page.title }}
  <!--{{- post_edit(post.source) }}-->
</h1>

<div class="post-meta">
  {%- if page.description %}
    <div class="post-description">{{ page.description }}</div>
  {%- endif %}
  <!--
  <div class="post-edit-link">
  {{- post_edit(post.source) }}
  </div>
  -->
  {% include '_partials/page/breadcrumb.swig' %}
</div>

</header>
