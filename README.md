# LSF data [![Build Status](https://travis-ci.org/parlr/lsf-data.svg?branch=master)](https://travis-ci.org/parlr/lsf-data)

> Vidéos et dictionnaire associés pour apprendre le vocabulaire LSF (Langue des Signes Française)

### Usage

    make split-video

### Test

**requirements:** [`bats`](https://github.com/bats-core/bats-core/).

    make test

### Install

**:warning: warning**: contains video files.

    git clone --recursive git@github.com:parlr/lsf-data.git
    cd lsf-data
    make install

### Source de données

- [LSF @ Éducation Nationale](http://lsf.education.fr/index.php?page=recherche_alphabetique)
- Apprendre 300 mots du quotidien en LSF [partie 1](https://www.youtube.com/watch?v=rz3jw0_XXoc) et [partie 2](https://www.youtube.com/watch?v=DbTKAbY-i0A) par L. Jauvert
- Primitives sémantiques
  - [La sémantique naturelle d’Anna Wierzbicka et les enjeux interculturels](https://journals.openedition.org/questionsdecommunication/4611) par  Arkadiusz Koselak, 2003.
  - [La métalangue sémantique naturelle: acquis et défis](https://www.academia.edu/5296087/La_m%C3%A9talangue_s%C3%A9mantique_naturelle_acquis_et_d%C3%A9fis) par  Bert Peeters, 2010.