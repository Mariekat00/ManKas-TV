import { getChannel } from "@/services/channels";
import { notFound } from "next/navigation";
import { ChannelDetail } from "@/components/channels/ChannelDetail";
import { getServerLocale } from "@/lib/locale-server";
import { t } from "@/lib/translations";

type ChannelPageProps = {
  params: Promise<{
    id: string;
  }>;
};

export async function generateMetadata({ params }: ChannelPageProps) {
  try {
    const { id } = await params;
    const locale = await getServerLocale();
    const channel = await getChannel(id);

    if (!channel) {
      return { title: "ManKas TV" };
    }

    return {
      title: `${channel.name} - ManKas TV`,
      description: `${t(locale, "channel.watch")} ${channel.name} ${t(locale, "live.live").toLowerCase()} ${t(locale, "nav.iptv").toLowerCase()}.`,
    };
  } catch {
    return { title: "ManKas TV" };
  }
}

export default async function ChannelPage({ params }: ChannelPageProps) {
  try {
    const { id } = await params;
    const channel = await getChannel(id);

    if (!channel) {
      notFound();
    }

    return <ChannelDetail channelId={id} />;
  } catch {
    notFound();
  }
}
