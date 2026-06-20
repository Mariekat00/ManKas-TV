import { NextResponse } from "next/server";
import { readFileSync } from "fs";
import { join } from "path";
import type { Channel } from "@/types";

// Guaranteed channels (verified working, always first)
const guaranteedChannels: Channel[] = [
  { id: "rmtv", name: "Real Madrid TV", logo: "https://upload.wikimedia.org/wikipedia/en/thumb/1/12/Real_Madrid_CF.svg/512px-Real_Madrid_CF.svg.png", stream_url: "https://rmtv.akamaized.net/hls/live/2043153/rmtv-es-web/master.m3u8", category: "Sports", country: "Spain", language: "Spanish", created_at: "" },
  { id: "gol-classics", name: "Gol Classics", logo: "https://img.icons8.com/fluency/512/soccer.png", stream_url: "https://d71gqtnep83vb.cloudfront.net/gol_classics/gol_classics.m3u8", category: "Sports", country: "Spain", language: "Spanish", created_at: "" },
  { id: "lequipe", name: "L'Equipe", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/L%27%C3%89quipe_wordmark.svg/640px-L%27%C3%89quipe_wordmark.svg.png", stream_url: "https://www.dailymotion.com/video/x2lefik", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "equidia", name: "Equidia", logo: "https://img.icons8.com/fluency/512/horse.png", stream_url: "https://raw.githubusercontent.com/Paradise-91/ParaTV/main/streams/equidia/live2.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "trace-sport-stars", name: "Trace Sport Stars", logo: "https://cdn-icons-png.flaticon.com/512/3112/3112948.png", stream_url: "https://lightning-tracesport-samsungau.amagi.tv/playlist.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "ftf-sports", name: "FTF Sports", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Logo_France_T%C3%A9l%C3%A9visions.svg/512px-Logo_France_T%C3%A9l%C3%A9visions.svg.png", stream_url: "https://1657061170.rsc.cdn77.org/HLS/FTF-LINEAR.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "telemundo-ny", name: "Telemundo NY", logo: "https://upload.wikimedia.org/wikipedia/commons/6/68/Telemundo_logo_2018.svg", stream_url: "https://nbculocallive.akamaized.net/hls/live/2037083/newyork/stream7/master.m3u8", category: "Sports", country: "USA", language: "Spanish", created_at: "" },
  { id: "arryadia", name: "Arryadia", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png", stream_url: "https://stream-lb.livemediama.com/arryadia/hls/master.m3u8", category: "Sports", country: "Morocco", language: "Arabic", created_at: "" },
  { id: "arryadia-hd1", name: "Arryadia HD1", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png", stream_url: "https://stream-lb.livemediama.com/arryadia-hd-01/hls/master.m3u8", category: "Sports", country: "Morocco", language: "Arabic", created_at: "" },
  { id: "bein-xtra", name: "beIN Sports XTRA", logo: "https://static.wikia.nocookie.net/logopedia/images/0/0b/BeIN_Xtra.PNG", stream_url: "https://bein-xtra-bein.amagi.tv/playlist.m3u8", category: "Sports", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "bein-xtra-es", name: "beIN Sports XTRA Español", logo: "https://static.wikia.nocookie.net/logopedia/images/0/0b/BeIN_Xtra.PNG", stream_url: "https://dc1644a9jazgj.cloudfront.net/beIN_Sports_Xtra_Espanol.m3u8", category: "Sports", country: "USA", language: "Spanish", created_at: "" },
  { id: "bein-sports-1", name: "beIN Sports 1", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/BeIN_Sports_logo_%28vertical_version%29.svg/500px-BeIN_Sports_logo_%28vertical_version%29.svg.png", stream_url: "http://23.237.104.106:8080/USA_BEIN/index.m3u8", category: "Sports", country: "USA", language: "English", created_at: "" },
  { id: "30a-golf", name: "30A Golf Kingdom", logo: "https://img.icons8.com/fluency/512/golf.png", stream_url: "https://30a-tv.com/feeds/vidaa/golf.m3u8", category: "Sports", country: "USA", language: "English", created_at: "" },
  { id: "as3-sport", name: "AS3 Sport TV", logo: "https://img.icons8.com/fluency/512/sports.png", stream_url: "https://streamtv.as3sport.online:3394/hybrid/play.m3u8", category: "Sports", country: "International", language: "English", created_at: "" },
  { id: "bahrain-sports-1", name: "Bahrain Sports 1", logo: "https://img.icons8.com/fluency/512/basketball.png", stream_url: "https://5c7b683162943.streamlock.net/live/ngrp:sportsone_all/playlist.m3u8", category: "Sports", country: "Bahrain", language: "Arabic", created_at: "" },
  { id: "cricket-gold", name: "Cricket Gold", logo: "https://img.icons8.com/fluency/512/cricket.png", stream_url: "https://streams2.sofast.tv/scheduler/scheduleMaster/418.m3u8", category: "Sports", country: "India", language: "English", created_at: "" },
  { id: "draftkings", name: "DraftKings Network", logo: "https://img.icons8.com/fluency/512/slot-machine.png", stream_url: "https://na.linear.zype.com/e0bd0e23-a958-4e43-8164-4f2fef8876a8/fd3614bd-90bf-4530-a277-65ae3a1720c8-zype/live.m3u8", category: "Sports", country: "USA", language: "English", created_at: "" },
  { id: "cazetv", name: "CazéTV", logo: "https://img.icons8.com/fluency/512/youtube-play.png", stream_url: "https://www.youtube.com/@cazetvoficial/live", category: "Sports", country: "Brazil", language: "Portuguese", created_at: "" },
  { id: "alkass-one", name: "Alkass One", logo: "https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass1-p/main.m3u8", category: "FIFA World Cup 2026", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "alkass-two", name: "Alkass Two", logo: "https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass2-p/main.m3u8", category: "FIFA World Cup 2026", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "alkass-three", name: "Alkass Three", logo: "https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass3-p/main.m3u8", category: "FIFA World Cup 2026", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "alkass-four", name: "Alkass Four", logo: "https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass4-p/main.m3u8", category: "FIFA World Cup 2026", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "bbc-one", name: "BBC One", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/BBC_One_logo_2021.svg/960px-BBC_One_logo_2021.svg.png", stream_url: "http://a.files.bbci.co.uk/media/live/manifesto/audio_video/simulcast/hls/uk/hls_tablet/ak/bbc_one_london.m3u8", category: "FIFA World Cup 2026", country: "UK", language: "English", created_at: "" },
  { id: "bbc-two", name: "BBC Two", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/BBC_Two_logo_2021.svg/960px-BBC_Two_logo_2021.svg.png", stream_url: "http://a.files.bbci.co.uk/media/live/manifesto/audio_video/simulcast/hls/uk/hls_tablet/ak/bbc_two_england.m3u8", category: "FIFA World Cup 2026", country: "UK", language: "English", created_at: "" },
  { id: "canal-sport", name: "Canal+ Sport", logo: "https://i.imgur.com/EOXnU15.png", stream_url: "http://151.80.18.177:86/Canal+_sport_HD/index.m3u8", category: "FIFA World Cup 2026", country: "France", language: "French", created_at: "" },
  { id: "canal-foot", name: "Canal+ Foot", logo: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Canal%2BFoot.png", stream_url: "https://test.946985.filegear-sg.me/proxy/ef3174f16d4557d2", category: "FIFA World Cup 2026", country: "France", language: "French", created_at: "" },
  { id: "ard-erde", name: "ARD (Das Erste)", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/ARD_Dachmarke_2014.svg/960px-ARD_Dachmarke_2014.svg.png", stream_url: "https://daserste-live.ard-mcdn.de/daserste/live/hls/int/master.m3u8", category: "FIFA World Cup 2026", country: "Germany", language: "German", created_at: "" },
  { id: "telemundo-intl", name: "Telemundo Internacional", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Telemundo_logo_2018.svg/960px-Telemundo_logo_2018.svg.png", stream_url: "http://138.121.15.230:9002/TELEMUNDO/index.m3u8", category: "FIFA World Cup 2026", country: "USA", language: "Spanish", created_at: "" },
  { id: "cctv-football", name: "CCTV Storm Football", logo: "https://i.imgur.com/Fy6HkX0.png", stream_url: "http://38.75.136.137:98/gslb/dsdqpub/fyzq.m3u8?auth=testpub", category: "FIFA World Cup 2026", country: "China", language: "Chinese", created_at: "" },
];

export async function GET() {
  try {
    const jsonPath = join(process.cwd(), "data", "iptv_channels.json");
    const content = readFileSync(jsonPath, "utf-8");
    const iptvChannels: Channel[] = JSON.parse(content);

    const allChannels = [...guaranteedChannels, ...iptvChannels];

    return NextResponse.json({ channels: allChannels }, {
      headers: { "Cache-Control": "no-store" },
    });
  } catch (e: any) {
    return NextResponse.json({
      channels: guaranteedChannels,
      error: e?.message || String(e),
      stack: e?.stack,
    }, {
      headers: { "Cache-Control": "no-store" },
    });
  }
}
