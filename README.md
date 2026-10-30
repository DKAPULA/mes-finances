# Mes Finances

Appli perso de suivi des finances en dirhams (PWA plein écran pour iPhone).
Hébergée sur GitHub Pages, données dans Supabase (protégées par compte, chaque utilisateur ne voit que ses lignes).

## Fichiers
- `index.html` : l'appli
- `config.js` : adresse et clé publique (anon) du projet Supabase
- `supabase.sql` : création des tables et des règles de sécurité (à lancer une fois)
- `manifest.webmanifest`, `sw.js`, `icons/` : installation plein écran sur iPhone

## Mise à jour
Après une modification, change `VERSION` dans `sw.js` (ex. `mes-finances-v2`) pour que l'iPhone recharge la nouvelle version.
