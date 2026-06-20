const FLAGS: Record<string, string> = {
  Mexico: "🇲🇽", "South Korea": "🇰🇷", "Czech Republic": "🇨🇿", "South Africa": "🇿🇦",
  "Bosnia and Herzegovina": "🇧🇦", Qatar: "🇶🇦", Switzerland: "🇨🇭", Canada: "🇨🇦",
  Curaçao: "🇨🇼", "Ivory Coast": "🇨🇮", Ecuador: "🇪🇨", Germany: "🇩🇪",
  Paraguay: "🇵🇾", Australia: "🇦🇺", Turkey: "🇹🇷", "United States": "🇺🇸",
  Japan: "🇯🇵", Sweden: "🇸🇪", Tunisia: "🇹🇳", Netherlands: "🇳🇱",
  Senegal: "🇸🇳", Iraq: "🇮🇶", Norway: "🇳🇴", France: "🇫🇷",
  Egypt: "🇪🇬", Iran: "🇮🇷", "New Zealand": "🇳🇿", Belgium: "🇧🇪",
  "Cape Verde": "🇨🇻", "Saudi Arabia": "🇸🇦", Uruguay: "🇺🇾", Spain: "🇪🇸",
  Panama: "🇵🇦", England: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", Croatia: "🇭🇷", Ghana: "🇬🇭",
  Algeria: "🇩🇿", Austria: "🇦🇹", Jordan: "🇯🇴", Argentina: "🇦🇷",
  Colombia: "🇨🇴", Portugal: "🇵🇹", "Democratic Republic of the Congo": "🇨🇩",
  Uzbekistan: "🇺🇿", Brazil: "🇧🇷", Italy: "🇮🇹",
  Morocco: "🇲🇦", Cameroon: "🇨🇲", Serbia: "🇷🇸",
  Poland: "🇵🇱", Peru: "🇵🇪", "Costa Rica": "🇨🇷",
  Scotland: "🏴󠁧󠁢󠁳󠁣󠁴󠁿", Denmark: "🇩🇰", Greece: "🇬🇷", "Republic of Ireland": "🇮🇪",
  Romania: "🇷🇴", Hungary: "🇭🇺", Slovakia: "🇸🇰", Ukraine: "🇺🇦",
  Israel: "🇮🇱", "North Macedonia": "🇲🇰", Georgia: "🇬🇪", Armenia: "🇦🇲",
  Finland: "🇫🇮", Iceland: "🇮🇸", Luxembourg: "🇱🇺", Belarus: "🇧🇾",
  Albania: "🇦🇱", Montenegro: "🇲🇪", Moldova: "🇲🇩",
  Lithuania: "🇱🇹", Latvia: "🇱🇻", Estonia: "🇪🇪",
};

export function getTeamFlag(teamName: string): string {
  return FLAGS[teamName] || "🏳️";
}
