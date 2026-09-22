# Minobot — Game Design Document

**Versione:** 0.1 (bozza iniziale)
**Piattaforma target:** Browser/Desktop (Godot 4, export HTML5 e Windows/Linux)
**Genere:** Platform a scorrimento orizzontale, 8-bit / pixel art
**Riferimento stilistico:** Super Mario Bros. (NES), con ambientazione ispirata al campo del Rugby Cernusco e alla metropolitana di Cernusco sul Naviglio

---

## 1. High concept

Minobot, il robot-giocatore del Rugby Cernusco, deve attraversare la città — dalla metropolitana al campo di allenamento fino alla clubhouse — per arrivare in tempo alla partita. Sulla strada affronta arbitri troppo zelanti, giocatori avversari dell'Iride Cologno, uno chef vegano ostile al mondo del salame e un istruttore di yoga che rallenta tutti quelli che passano. Il livello si conclude in clubhouse, dove Minobot affronta lo chef vegano Jean-François in un boss fight, per poi attraversare la porta a H e segnare la meta della vittoria.

## 2. Protagonista: Minobot

| Attributo | Valore |
|---|---|
| Aspetto | Robusto, pelato, con barbetta |
| Outfit | Maglia Rugby Cernusco (corpo amaranto, fascia grigia centrale, dettagli bianchi) + pantaloncini neri |
| Vite | 3 (sistema classico, game over a 0) |
| Stato a inizio livello | 3 vite, nessun power-up attivo, munizioni speciali a 0 |

### 2.1 Movimento

- Camminata / corsa orizzontale
- Salto (altezza fissa, leggermente modulabile tenendo premuto il tasto — *variable jump height*)
- Nessun doppio salto nella v0.1 (valutabile in futuro come power-up)

### 2.2 Attacco

Minobot ha due "slot" di lancio:

1. **Palla da rugby** — munizione standard, illimitata, danno base. Sempre disponibile.
2. **Speciale** — usa per prima la scorta di **Salame**, poi quella di **Grana Padano** se il salame è esaurito. Munizioni limitate, raccolte nei livelli.

Il Grana Padano è pensato come riserva da risparmiare per il boss finale (danno molto più alto), ma il giocatore è libero di usarlo prima se preferisce.

## 3. Collezionabili e power-up

| Oggetto | Effetto | Durata / consumo |
|---|---|---|
| 🍺 Birra | Aumenta la velocità di movimento | Timer 8s, non stackabile (il pickup successivo ricarica il timer) |
| 🌭 Salame | Munizione speciale lanciabile, danno medio | Consumabile, +1 alla scorta per pickup |
| 🏉 Palla da rugby | Munizione standard | Illimitata (nessun consumo) |
| 🧀 Grana Padano | Arma speciale definitiva, danno alto, pensata per il boss | Consumabile e raro, +1 alla scorta per pickup |

## 4. Nemici

| Nemico | Comportamento | Vita | Danno a contatto |
|---|---|---|---|
| Arbitro (Rugby Cernusco) | Pattuglia un tratto fisso; se il giocatore entra nella sua zona di allerta, si ferma e "fischia", rallentando brevemente Minobot | 1 colpo | 1 vita |
| Giocatore Iride Cologno (maglia a strisce) | Pattuglia; se avvista il giocatore alla stessa altezza entro un certo raggio, parte in **scatto/carica** verso di lui | 2 colpi | 1 vita |
| Chef Vegano | Perlopiù fermo, lancia verdure a intervalli regolari verso il giocatore se è nel raggio | 2 colpi | 1 vita (contatto) + proiettile verdura |
| Istruttore di Yoga | Fermo, emette un'aura che rallenta Minobot finché resta nel raggio | 1 colpo | Nessun danno diretto, solo debuff di velocità |

Tutti i nemici possono essere eliminati con palla da rugby, salame o Grana Padano; ogni colpo subito da Minobot lo rimanda al checkpoint più vicino con perdita di una vita e un breve periodo di invulnerabilità.

## 5. Struttura del livello

Per la v0.1 il gioco è **un unico livello lungo, diviso in tre sezioni** che si susseguono senza schermate di caricamento, in scorrimento continuo (coerente con la richiesta di un livello unico a sezioni):

```
[Sezione A: Metropolitana] → [Sezione B: Campo da Rugby] → [Sezione C: Clubhouse + Boss]
      0% ────────────────────────── 100%
```

### 5.1 Sezione A — Metropolitana (Cernusco sul Naviglio)

- Ambientazione: banchina, pensiline, cartelli direzionali, palette blu/grigio tipica della metro
- Piattaforme sopra i binari, ostacoli legati ai cartelli/pensiline
- Nemici: Arbitri (pattuglia sulla banchina), qualche Giocatore Iride Cologno
- Collezionabili: birre e palle da rugby sparse, primo salame

### 5.2 Sezione B — Campo da rugby

- Ambientazione: erba, linee di campo, pali, panchine
- Piattaforme su tribune/attrezzature da allenamento
- Nemici: Giocatori Iride Cologno (cariche), Istruttore di Yoga (fermo, aura)
- Collezionabili: salami, birre, primo Grana Padano

### 5.3 Sezione C — Clubhouse (boss arena)

- Ambientazione: interno/esterno clubhouse, cucina in vista
- Arena piatta e ampia, pensata per il combattimento
- Nemico: **Jean-François** (boss)
- Dopo la vittoria: attraversamento della porta a H → schermata di vittoria ("Meta!")

## 6. Boss fight — Jean-François (chef vegano)

- **Location:** clubhouse del Rugby Cernusco
- **Vita:** valore alto rispetto ai nemici normali (v0.1: 20 punti vita)
- **Pattern d'attacco**, alternati a tempo:
  - *Volley di verdure*: lancia 3 proiettili a ventaglio verso Minobot
  - *Carica*: attraversa l'arena a velocità elevata, obbligando il giocatore a saltare/schivare
- Man mano che la vita scende, i tempi di recupero tra un attacco e l'altro si riducono (difficoltà crescente)
- **Debolezza:** il Grana Padano infligge danno molto superiore a palla da rugby/salame — è l'arma pensata per chiudere lo scontro rapidamente
- **Fine scontro:** alla sconfitta di Jean-François si sblocca il passaggio verso la porta a H; attraversandola il giocatore vince il livello ("segna la meta")

## 7. Controlli (v0.1, tastiera)

| Azione | Tasto |
|---|---|
| Muovi sinistra/destra | ← → (o A/D) |
| Salta | Spazio |
| Lancia palla da rugby | J |
| Lancia speciale (salame/Grana) | K |
| Pausa | Esc |

Gamepad e touch (mobile) sono fuori scope per la v0.1, valutabili come estensione futura.

## 8. UI / HUD

- Vite rimanenti (icone)
- Punteggio
- Scorta munizioni speciali (salame / Grana Padano, con icona di quello attivo)
- Barra vita del boss, visibile solo durante il boss fight

## 9. Art direction

Riferimenti visivi reali forniti dal committente:

- **Palette metropolitana:** blu/azzurro della struttura, grigio del cemento, verde-giallo dei cartelli di stazione (Cernuscosulnaviglio)
- **Palette campo/clubhouse:** amaranto e grigio della maglia sociale Rugby Cernusco, verde prato, dettagli bianchi/neri della clubhouse in rendering
- **Maglia Iride Cologno:** strisce orizzontali per differenziare a colpo d'occhio i nemici "avversari" dai nemici "ambientali" (arbitro, chef, istruttore)

Nella v0.1 del prototipo tutti gli sprite sono **placeholder geometrici colorati** (rettangoli/poligoni) che rispettano già la palette definitiva, in attesa della pixel art definitiva (vedi `README.md`, sezione asset).

## 10. Audio (direzione, non ancora implementato in v0.1)

- Musica: chiptune energico per le sezioni di gioco, tema diverso e più teso per il boss fight
- SFX: fischietto arbitro, "thud" di lancio/impatto, applauso alla meta finale

## 11. Architettura tecnica (Godot 4)

```
Main.tscn
 ├─ MainMenu.tscn        (schermata iniziale)
 └─ Level.tscn
     ├─ Minobot (player, CharacterBody2D)
     ├─ Enemies (Referee / IridePlayer / VeganChef / YogaInstructor / JeanFrancois)
     ├─ Pickups (Beer / Salami / GranaPadano)
     ├─ TileMap (piattaforme/terreno)
     ├─ Backgrounds (per sezione A/B/C)
     ├─ HUD.tscn (CanvasLayer)
     └─ EndScreen.tscn (vittoria / game over)

Autoload:
 └─ GameManager (singleton): vite, punteggio, munizioni, checkpoint, segnali globali
```

- Linguaggio: GDScript
- Fisica: `CharacterBody2D` per player/nemici, `Area2D` per proiettili/pickup/trigger
- Comunicazione tra sistemi tramite **segnali** (nessun accoppiamento diretto tra HUD e player: il player/GameManager emette, la HUD ascolta)
- Layer di collisione dedicati: mondo, player, nemici, proiettili giocatore, proiettili nemici, pickup

## 12. Scope v0.1 vs estensioni future

**Dentro lo scope attuale:** tutto quanto descritto sopra, un livello unico a tre sezioni, 4 nemici + 1 boss, 4 power-up/collezionabili, HUD base, vittoria/game over.

**Fuori scope (idee future, non richieste ora):** livelli aggiuntivi, gamepad/touch, salvataggio dei progressi, classifiche punteggio, musica/SFX definitivi, pixel art definitiva in sostituzione dei placeholder.
