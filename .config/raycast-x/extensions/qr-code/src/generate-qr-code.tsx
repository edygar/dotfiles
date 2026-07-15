import {
  Action,
  ActionPanel,
  Detail,
  Form,
  Icon,
  showInFinder,
  showToast,
  Toast,
} from "@raycast/api";
import { copyFile, mkdir, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";
import { useState } from "react";
import QRCode, { type QRCodeErrorCorrectionLevel } from "qrcode";

type FormValues = {
  content: string;
  errorCorrectionLevel: QRCodeErrorCorrectionLevel;
};

type Result = {
  content: string;
  errorCorrectionLevel: QRCodeErrorCorrectionLevel;
  pngPath: string;
  svgPath: string;
  svg: string;
};

const supportDir = join(
  homedir(),
  "Library",
  "Application Support",
  "com.raycast.macos",
  "extensions",
  "qr-code",
);
const pngPath = join(supportDir, "qr-code.png");
const svgPath = join(supportDir, "qr-code.svg");
const previewSize = 320;

export default function Command() {
  const [result, setResult] = useState<Result>();

  async function generate(values: FormValues) {
    const content = values.content.trim();
    if (!content) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Enter text or a URL",
      });
      return;
    }

    const svg = await QRCode.toString(content, {
      type: "svg",
      width: 512,
      margin: 2,
      errorCorrectionLevel: values.errorCorrectionLevel,
      color: {
        dark: "#000000",
        light: "#ffffff",
      },
    });

    await mkdir(supportDir, { recursive: true });
    await writeFile(svgPath, svg, "utf8");
    await QRCode.toFile(pngPath, content, {
      type: "png",
      width: previewSize,
      margin: 2,
      errorCorrectionLevel: values.errorCorrectionLevel,
      color: {
        dark: "#000000",
        light: "#ffffff",
      },
    });
    setResult({
      content,
      errorCorrectionLevel: values.errorCorrectionLevel,
      pngPath,
      svgPath,
      svg,
    });
  }

  if (result)
    return <Preview result={result} onBack={() => setResult(undefined)} />;

  return (
    <Form
      actions={
        <ActionPanel>
          <Action.SubmitForm
            icon={Icon.QrCode}
            title="Generate QR Code"
            onSubmit={generate}
          />
        </ActionPanel>
      }
    >
      <Form.TextArea
        id="content"
        title="Text or URL"
        placeholder="https://example.com"
        autoFocus
      />
      <Form.Dropdown
        id="errorCorrectionLevel"
        title="Error Correction"
        defaultValue="M"
      >
        <Form.Dropdown.Item value="L" title="Low" />
        <Form.Dropdown.Item value="M" title="Medium" />
        <Form.Dropdown.Item value="Q" title="Quartile" />
        <Form.Dropdown.Item value="H" title="High" />
      </Form.Dropdown>
    </Form>
  );
}

function Preview({ result, onBack }: { result: Result; onBack: () => void }) {
  const markdown = `![Generated QR Code](${pathToFileURL(result.pngPath).href})`;

  return (
    <Detail
      markdown={markdown}
      metadata={
        <Detail.Metadata>
          <Detail.Metadata.Label title="Content" text={result.content} />
          <Detail.Metadata.Label
            title="Error Correction"
            text={result.errorCorrectionLevel}
          />
        </Detail.Metadata>
      }
      actions={
        <ActionPanel>
          <Action.CopyToClipboard
            icon={Icon.Clipboard}
            title="Copy SVG"
            content={result.svg}
          />
          <Action.CopyToClipboard
            icon={Icon.Text}
            title="Copy Source Text"
            content={result.content}
          />
          <Action
            title="Save PNG to Downloads"
            icon={Icon.Download}
            onAction={() => saveToDownloads(result)}
          />
          <Action.ShowInFinder path={result.pngPath} />
          <Action
            title="Generate Another"
            icon={Icon.ArrowCounterClockwise}
            onAction={onBack}
          />
        </ActionPanel>
      }
    />
  );
}

async function saveToDownloads(result: Result) {
  const filename = `${slugify(result.content)}.png`;
  const destination = join(homedir(), "Downloads", filename);

  await copyFile(result.pngPath, destination);
  await showToast({
    style: Toast.Style.Success,
    title: "Saved QR code",
    message: filename,
  });
  await showInFinder(destination);
}

function slugify(value: string) {
  const slug = value
    .toLowerCase()
    .replace(/^https?:\/\//, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 48);

  return slug || "qr-code";
}
