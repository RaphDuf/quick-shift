# Guide de connexion au VPN Cloud (WireGuard)
Ce guide explique comment se connecter au réseau cloud privé (Oracle) depuis un poste de travail Windows

## Windows
### Prérequis
Téléchargez et installez le client officiel [WireGuard pour Windows](https://www.wireguard.com/install/).

### Obtenir son fichier de configuration personnel
*Si vous possédez déjà votre fichier `.conf` (ex: `Oracle.conf`), vous pouvez passer directement à la section suivante.*

Chaque appareil nécessite une configuration unique (1 appareil = 1 fichier). Pour générer une nouvelle configuration depuis le serveur Bastion :
1. Connectez-vous au serveur Bastion en SSH : `ssh -i ~/.ssh/id_ed25519_oracle ubuntu@xxx`
2. Lancez le script de gestion WireGuard : `sudo ./wireguard-install.sh`
3. Le menu s'affiche. Choisissez l'option `1) Add a new client.`
4. Saisissez un nom d'identifiant pour votre poste (ex: pc-nom-prenom) et appuyez sur Entrée pour valider les adresses IP internes proposées.
5. Le script génère un fichier dans le dossier courant. Affichez son contenu avec : `cat nom-choisi.conf`
6. Sélectionnez et copiez l'intégralité du texte affiché.
7. Sur votre PC Windows, dans Document, créez un nouveau fichier texte, collez le contenu, et enregistrez-le sous le nom Oracle.conf.

### Activer la connexion VPN
1. Ouvrez le menu Démarrer de Windows et cherchez **cmd** (Invite de commandes).
2. Faites un clic droit > **Exécuter en tant qu'administrateur**.
3. Lancez la commande suivante (adaptez le nom du fichier si nécessaire) : `"C:\Program Files\WireGuard\wireguard.exe" /installtunnelservice "%USERPROFILE%\Documents\Oracle.conf"`
Le tunnel s'exécute maintenant en tâche de fond. Tout le trafic internet et réseau est chiffré et routé via le Bastion Cloud.

### Désactiver la connexion VPN
1. Ouvrez le menu Démarrer de Windows et cherchez **cmd** (Invite de commandes).
2. Lancez cette commande : `"C:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice Oracle`
(Note : "Oracle" correspond au nom de votre fichier sans l'extension .conf).



## Smartphone (iOS ou Android)
### L'installation sur mobile
1. Téléchargez l'application officielle WireGuard (disponible sur l'App Store ou Google Play Store).
2. Ouvrez l'application WireGuard.
3. Appuyez sur le bouton "+" (en haut à droite sur iOS, ou en bas à droite sur Android).
4. Choisissez l'option "Scanner un code QR" (ou Create from QR code).
5. Scannez le QR code (dispo [ici](./images/WireGuard-QR-code.png)).
6. L'application va vous demander de donner un nom à ce tunnel. Tapez un nom simple (ex: VPN-Oracle) et validez.
Et voilà ! Le tunnel est ajouté avec toutes les clés de chiffrement et les adresses IP déjà parfaitement configurées.