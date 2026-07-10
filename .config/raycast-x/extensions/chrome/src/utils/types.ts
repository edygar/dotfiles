export interface ChromeTab {
  index: number;
  title: string;
  url: string;
  active: boolean;
}

export interface ChromeWindow {
  id: number;
  name: string;
  activeTabIndex: number;
  incognito: boolean;
  tabs: ChromeTab[];
  isFrontmost: boolean;
}
