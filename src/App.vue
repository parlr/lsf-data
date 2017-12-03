<template>
  <div id="top">
    <nav class="navbar is-fixed-top is-primary" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <div class="navbar-item control search">
          <input v-model="search"
                 @click="focus()"
                 @keyup="displayIndex()"
                 @keyup.enter="playFirst()"
                 id="search"
                 placeholder="comment signer…"
                 class="input search"
                 autofocus
                 autocomplete="off"
                 type="text">
        </div>
        <label for="search" class="navbar-item is-paddingless is-hidden-mobile">{{count}} Résultats</label>
      </div>
    </nav>

    <section class="content">
      <div class="container is-fluid">
        <main class="tile is-ancestor layout">
          <nav v-if="showIndex && count > 0" class="tile is-vertical is-2">
            <div class="tile is-parent index" role="navigation" aria-label="words index">
              <div class="tile is-child">
                <ul class="index_content">
                  <li v-for="mot in filteredMots" class="index_content--item has-bottom-margin">
                    <a href="#top" @click="play(mot)"
                       :id="mot.key"
                       :inner-html.prop="mot.label | highlight(search)">
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </nav>
          <aside class="tile is-parent video">
            <figure class="tile is-child">
              <figcaption>
                <video :src="videoPlaying.video"
                       @click="playPause($event)"
                       controls
                       loop
                       muted
                       autoplay
                >
                  <a class="button is-primary is-loading">Button</a>
                </video>
              </figcaption>
            </figure>
          </aside>
        </main>
      </div>
    </section>
    <footer>
      <navbar-bottom></navbar-bottom>
    </footer>
  </div>
</template>

<script>
  import got from 'got';
  import dataset from './assets/vocabulaire.json';
  import {highlight} from './filters.js';
  import './lsf.scss';
  import navbarBottom from './navbar-bottom.vue';

  export default {
    components: {
      'navbar-bottom': navbarBottom
    },
    name: 'app',
    data: function () {
      return {
        search: '',
        showIndex: true,
        vocabulaire: [],
        videoPlaying: {label: undefined}
      };
    },
    created: function () {
      this.vocabulaire = dataset;
    },
    mounted: function () {
      this.player = document.querySelector('video');
    },
    computed: {
      count: function () {
        return this.filteredMots.length;
      },
      filteredMots: function () {
        return this.vocabulaire.filter(
          mot =>
            mot.label.indexOf(this.search) !== -1 ||
            mot.key.indexOf(this.search) !== -1
        );
      }
    },
    methods: {
      focus: function () {
        window.scrollTo(0, 0);
      },
      displayIndex: function () {
        this.showIndex = true;
      },
      play: function (mot) {
        this.showIndex = false;
        this.search = mot.label;
        this.videoPlaying = mot;
      },
      playFirst: function () {
        this.play(this.filteredMots[0]);
      },
      playPause: function (event) {
        this.player.paused ? this.player.play() : this.player.pause();
      }
    },
    filters: {
      highlight
    }
  };
</script>
<style scoped>
  .index_content--item {
    padding: 0 1rem 0 calc(1rem + 0.750em - 1px);
    line-height: 1.5rem;
  }
</style>
