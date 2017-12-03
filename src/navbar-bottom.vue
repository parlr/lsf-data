<template>
  <nav class="navbar is-fixed-bottom is-light">
    <div class="navbar-brand has-text-weight-bold">
      <span class="navbar-item" @click="showIndex=true">
        <img :src="listIcon" class="fa" alt="">
        Liste
      </span>
      <span class="navbar-item" @click="random()">
        <img :src="randomIcon" class="fa" alt="">
        Aléatoire
      </span>
    </div>
  </nav>
</template>
<script>
  import randomIcon from 'font-awesome-svg-png/black/svg/random.svg'
  import listIcon from 'font-awesome-svg-png/black/svg/list.svg'

  export default {
    data: function () {
      return {
        randomIcon,
        listIcon
      }
    },
  }
</script>
<style scoped>
  .fa {
    height: 22px;
    margin-right: .5rem;
  }
</style>
