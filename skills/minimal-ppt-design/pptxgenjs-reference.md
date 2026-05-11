# PptxGenJS Implementation Reference

For use with the `minimal-ppt-design` skill. Implements the full slide spec as reusable helper functions.

Tested against **pptxgenjs@3.x**. Install: `npm install pptxgenjs`

```javascript
const pptxgen = require("pptxgenjs");
const pres = new pptxgen();
pres.layout = "LAYOUT_16x9"; // 10" x 5.625"

const BLACK = "000000";
const WHITE = "FFFFFF";
const LIGHT_GRAY = "AAAAAA";
const MID_GRAY = "666666";
const BORDER_GRAY = "CCCCCC";

function addTitleSlide(title, subtitle) {
  const slide = pres.addSlide();
  slide.background = { color: WHITE };
  slide.addText(title, {
    x: 0.5, y: 1.6, w: 9, h: 1.4,
    fontSize: 36, bold: true, color: BLACK,
    align: "center", fontFace: "Arial",
  });
  if (subtitle) {
    slide.addText(subtitle, {
      x: 0.5, y: 3.2, w: 9, h: 0.7,
      fontSize: 20, color: MID_GRAY, italic: true,
      align: "center", fontFace: "Arial",
    });
  }
}

// sections: string[]
function addContentsSlide(sections) {
  const slide = pres.addSlide();
  slide.background = { color: WHITE };
  slide.addText("Contents", {
    x: 0.5, y: 0.25, w: 9, h: 0.65,
    fontSize: 28, bold: true, color: BLACK,
    align: "left", fontFace: "Arial", margin: 0,
  });
  const runs = sections.map((s, i) => ({
    text: s,
    options: { bullet: true, breakLine: i < sections.length - 1 },
  }));
  slide.addText(runs, {
    x: 0.5, y: 1.05, w: 9, h: 4.0,
    fontSize: 15, color: BLACK, fontFace: "Arial",
    align: "left", paraSpaceAfter: 4,
  });
}

function addDividerSlide(num, name) {
  const slide = pres.addSlide();
  slide.background = { color: WHITE };
  slide.addText(`Section ${num}`, {
    x: 0.5, y: 1.5, w: 9, h: 0.6,
    fontSize: 20, color: MID_GRAY,
    align: "center", fontFace: "Arial",
  });
  slide.addText(name, {
    x: 0.5, y: 2.15, w: 9, h: 1.6,
    fontSize: 36, bold: true, color: BLACK,
    align: "center", fontFace: "Arial",
  });
}

// items: { text, bold?, indent?, numbered?, noBullet? }[]
function addContentSlide(title, ref, items, diagramNote) {
  const slide = pres.addSlide();
  slide.background = { color: WHITE };
  slide.addText(title, {
    x: 0.5, y: 0.25, w: 9, h: 0.65,
    fontSize: 28, bold: true, color: BLACK,
    align: "left", fontFace: "Arial", margin: 0,
  });
  if (ref) {
    slide.addText(ref, {
      x: 0.5, y: 0.88, w: 9, h: 0.28,
      fontSize: 11, color: LIGHT_GRAY, italic: true,
      align: "left", fontFace: "Arial", margin: 0,
    });
  }
  const bodyY = ref ? 1.25 : 1.05;
  const bodyH = diagramNote ? 2.8 : 4.0;
  const runs = items.map((item, i) => ({
    text: item.text,
    options: {
      bold: item.bold || false,
      breakLine: i < items.length - 1,
      indentLevel: item.indent || 0,
      bullet: item.numbered ? { type: "number" } : item.noBullet ? false : true,
    },
  }));
  slide.addText(runs, {
    x: 0.5, y: bodyY, w: 9, h: bodyH,
    fontSize: 15, color: BLACK, fontFace: "Arial",
    align: "left", paraSpaceAfter: 4,
  });
  if (diagramNote) {
    slide.addShape(pres.shapes.RECTANGLE, {
      x: 0.5, y: 4.35, w: 9, h: 0.85,
      fill: { color: "F5F5F5" },
      line: { color: BORDER_GRAY, width: 1 },
    });
    slide.addText(`[DIAGRAM: ${diagramNote}]`, {
      x: 0.55, y: 4.38, w: 8.9, h: 0.79,
      fontSize: 12, color: MID_GRAY, italic: true,
      fontFace: "Arial", align: "center", valign: "middle",
    });
  }
}

// answerBullets: string[]
function addQASlide(source, question, answerBullets) {
  const slide = pres.addSlide();
  slide.background = { color: WHITE };
  slide.addText("Past Paper Practice", {
    x: 0.5, y: 0.25, w: 9, h: 0.65,
    fontSize: 28, bold: true, color: BLACK,
    align: "left", fontFace: "Arial", margin: 0,
  });
  slide.addText(source, {
    x: 0.5, y: 0.88, w: 9, h: 0.28,
    fontSize: 11, color: LIGHT_GRAY, italic: true,
    align: "left", fontFace: "Arial", margin: 0,
  });
  slide.addText(question, {
    x: 0.5, y: 1.25, w: 9, h: 0.6,
    fontSize: 14, bold: true, color: BLACK,
    align: "left", fontFace: "Arial",
  });
  const runs = answerBullets.map((a, i) => ({
    text: a,
    options: { bullet: true, breakLine: i < answerBullets.length - 1 },
  }));
  slide.addText(runs, {
    x: 0.5, y: 1.95, w: 9, h: 3.3,
    fontSize: 13, color: BLACK, fontFace: "Arial",
    align: "left", paraSpaceAfter: 4,
  });
}

// Closing/summary table slide is ad-hoc - column count and row data vary per deck.
// Follow the spec: dark header row (#333333 fill, white text), CCCCCC borders, 11pt Arial.

pres.writeFile({ fileName: "output.pptx" }).then(() => console.log("Done."));
```