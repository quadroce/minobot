# Minobot

Platform a scorrimento orizzontale in stile 8-bit ispirato al Rugby Cernusco. Il design completo è in [`docs/GDD.md`](docs/GDD.md); questo file copre come aprire ed eseguire il prototipo.

## Requisiti

- [Godot Engine 4.3+](https://godotengine.org/download) (build "Standard", non serve .NET)

## Come avviare il prototipo

1. Apri Godot Engine, scegli **Import**, seleziona `project.godot` in questa cartella
2. Premi **F5** (o il tasto Play) per avviare da `scenes/Main.tscn`

## Stato del prototipo (v0.1)

Implementato:

- Movimento, salto, invulnerabilità/knockback, sistema a 3 vite con respawn su checkpoint
- Lancio palla da rugby (illimitata) + arma speciale (salame poi Grana Padano, con scorte raccolte nel livello)
- 4 tipi di nemico (Arbitro, Giocatore Iride Cologno, Chef Vegano, Istruttore di Yoga) + boss finale Jean-François con pattern d'attacco a due fasi
- Power-up: birra (boost velocità), salame, Grana Padano
- Livello unico a tre sezioni (Metropolitana → Campo da rugby → Clubhouse) con sfondi differenziati
- HUD (vite, punteggio, munizioni, barra vita boss), schermata iniziale e schermata di vittoria/game over

**Non ancora implementato / TODO:**

- **Pixel art definitiva**: tutti gli sprite sono placeholder geometrici colorati (`Polygon2D`) che rispettano già la palette descritta nel GDD, in attesa degli asset pixel-art veri
- Musica e SFX (attualmente il gioco è muto)
- Gamepad/touch (solo tastiera)
- Bilanciamento reale di velocità, danni e posizionamento di nemici/piattaforme: i valori attuali sono una prima bozza pensata per essere rifinita direttamente nell'editor

## Controlli

| Azione | Tasto |
|---|---|
| Muovi | ← → oppure A / D |
| Salta | Spazio |
| Lancia palla da rugby | J |
| Lancia arma speciale | K |
| Conferma menu / torna al menu | Invio |

## Struttura del progetto

```
project.godot
scripts/
  autoload/game_manager.gd   # Stato di run (vite, punteggio, munizioni, checkpoint)
  player/minobot.gd
  enemies/                   # enemy_base.gd + le 4 sottoclassi + il boss
  projectiles/                # base + varianti player/nemico (riusate dalle 4 scene proiettile)
  pickups/pickup.gd           # riusato da birra/salame/Grana Padano
  level/level.gd
  ui/                          # hud.gd, main_menu.gd, end_screen.gd
scenes/                        # una scena per ogni script sopra, più Level.tscn e Main.tscn
docs/GDD.md                    # documento di design completo
```

## Nota

Questo prototipo non è mai stato aperto in Godot durante la creazione (l'editor non è disponibile in questo ambiente): la logica e le scene sono state scritte a mano seguendo rigorosamente il formato `.tscn`/GDScript di Godot 4.3, ma vanno verificate aprendo il progetto. Se all'avvio l'editor segnala errori (nodi mancanti, percorsi sbagliati, ecc.), segnalali: si sistemano rapidamente.
