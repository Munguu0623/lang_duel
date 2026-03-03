1) Гол шалтгаан: Palette чинь “warm cream + border” ихтэй → хуучин харагдана

Танайд:

background: #F6F8F6 (ногоовтордуу, “paper” мэдрэмж)

surfaceGrey: #EDE7D9 + border #E0D8C8 → beige + хүрээ = Notion/old dashboard vibe

Шийдэл (шууд нүдэнд modern болгоно)

Background-аа илүү neutral болго:
#F7F8FC эсвэл #0B0F1A (dark mode default хийхээр бүр л шинэ)

Border-оо 60% багасга: card бүрийг хүрээлээд байхаар хуучин санагддаг. Border бол “data table” дээр л хэрэгтэй.

SurfaceGrey-оо бараг хэрэглэхгүй: оронд нь “tint” ашигла: primary-ийн 3–6% tint.

2) Hierarchy асуудал: Бүх юм card → бүх юм адилхан → “хуучин”

Home дээр:

Header

Quick stats

CTA

Season

Recent matches
… бүгд нэг “card stack” маягтай. Энэ нь хэрэглэгчид юу хамгийн чухал вэ гэдгийг шууд мэдрүүлэхгүй.

Шийдэл: 1 screen = 1 hero, бусад нь supporting

Home-ийн шинэ бүтэц (modern pattern):

Hero CTA (1 л том зүйл)

“Start Duel” ганцаараа spotlight байг.

Доор нь жижиг 2 pill: “Rank #128”, “Win rate 62%”

Progress section (one clean chart/card)

Recent matches list (borderless list style, card биш)

👉 Гол санаа: Card-аа багасга, whitespace нэм. Modern харагдана.

3) Typography: Font зөв ч sizing scale жаахан “safe”

Plus Jakarta Sans бол гоё. Гэхдээ modern app-ууд:

Title дээр илүү том + илүү tight

Secondary текст дээр илүү low contrast

Number/Stats дээр tabular/mono feel (эсвэл heavy weight)

Шийдэл

Headline-аа нэг шат өсгө (жишээ: 28 → 30/32 мэдрэмж)

Stats тоонуудыг bolder + bigger болго (жишээ “62%”, “#128”, “7 streak”)

Subtitle-уудыг богино + 1 мөр болго. “60 seconds. AI judges.” сайн байна, гэхдээ бүх газар ийм богино хэлбэр барь.

4) Component styling: “Icon badge in a square” их давтагдвал хуучин

48x48 дөрвөлжин badge чинь цэвэрхэн ч олон давтагдвал “template” шиг харагддаг.

Шийдэл (visual spice, modern болгох жижиг трюк)

Badge-аа зарим газар circle болгож соль.

Зарим card дээр subtle gradient overlay (primary 6% → transparent) хэрэглэ.

CTA дээр one signature visual: glow / gradient stroke / subtle noise texture (нэгийг нь л сонго, олон биш).

5) Motion: “Амьтай” биш бол хуучин

Танайд motion token байна. Гэхдээ modern мэдрэмжийг:

Screen entry дээр жижиг stagger

CTA press дээр tactile

Result дээр count-up / confetti micro

Шийдэл

Only 3 micro-interaction нэм:

CTA card орж ирэхэд slight fade + up (180–240ms)

Button дарахад scale 0.98 + glow boost

Result score count-up + жижиг shimmer

(Илүүг нэмбэл хүүхдийн тоглоом шиг болно, 3 хангалттай.)

6) Navigation: Floating pill зөв, гэхдээ “glass” хийвэл бүр шинэ харагдана

Одоогийн nav чинь OK. Modern болгох хамгийн амархан upgrade:

Background дээр blur/glass мэдрэмж (маш бага)

Active state дээр зөвхөн fill биш, active indicator dot / underline (minimal)

7) “Modern UI” болгох 10 Quick Wins (маргаашнаас шууд)

Background-аа neutral болгож өөрчил

Border хэрэглээг 60% бууруул

Card тоог цөөл (ялангуяа list дээр)

Home дээр 1 л Hero CTA үлдээ

Stats-аа big-number style болго

Subtitle-уудыг богино, нэг мөр

Icon badge хэлбэрийг mix (circle/squircle)

CTA дээр signature gradient/glow нэг л газар

Empty state-уудыг илүү “graphic” болго (simple illustration vibe)

Spacing-аа өсгө: section хооронд xl/xxl илүү ашигла

8) Миний санал болгож байгаа “шинэ visual direction” (English Duel / Oyun style-д таарна)
Direction A — Sporty Neon Minimal

Dark mode default (#0B0F1A)

Primary: electric blue / cyan

Cards: borderless, soft glow

Stats: big numbers, leaderboard “podium” илүү гоё харагдана

Direction B — Clean Premium Light

Background: #F7F8FC

Surfaces: pure white

Accent: primary blue + 1 secondary (violet эсвэл mint)

Borders бараг 0, shadow subtle