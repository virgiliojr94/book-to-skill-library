# Wrapper de prompt — MoneyPrinterTurbo × mrbeast-production

Cola isso no `--video-subject` (CLI) ou no campo de tópico do WebUI/AI Agent do MoneyPrinterTurbo, preenchendo os `[...]`.

**Teto honesto**: o MPT usa stock footage genérico (Pexels/Pixabay/Coverr) + TTS. Isso resolve TÓPICO e ESTRUTURA do roteiro — não resolve "wow factor" (ch01), que exige asset próprio (persona, prop, locação). Sem isso, o CTR real fica abaixo do que os frameworks prometem. Use a skill aqui pra não desperdiçar um vídeo em tópico fraco, não espere viralização de engine genérico.

---

```
Tópico: [ideia extrema/inusitada — não genérica; teste: "isso faria alguém parar de rolar o feed em 1s?"]

Escreva um roteiro de [14-59]s nesta estrutura:

1. HOOK (primeiros 1-2s): declare o resultado mais chocante/inesperado ANTES de explicar como chegou lá. Nada de introdução.
2. ESCALADA (corpo, ~60-70% do tempo): 2-3 degraus de stakes crescentes — cada corte aumenta o absurdo/tensão em relação ao anterior (stair stepping). Não repita o mesmo nível de intensidade duas vezes seguidas.
3. PAYOFF (final): entrega o que o hook prometeu, de forma clara o bastante pra alguém sem contexto entender de primeira (simplicidade — se precisa explicar, cortou errado).

Restrição: cada frase deve caber numa pessoa comum entender sem pausar o vídeo.
```

---

Config sugerida no MPT (ajustar por lote, não por vídeo):
- Formato: 9:16 pra Reels/Shorts/TikTok (padrão), 16:9 só se destino for YouTube longo
- Rotação: não usar o mesmo template de hook em 2 vídeos seguidos do mesmo lote (batch) — varia estrutura pra não cansar a mesma audiência

Referência completa: `SKILL.md`, `chapters/ch01` (virality/hook), `chapters/ch03` (stair stepping/simplicidade).
