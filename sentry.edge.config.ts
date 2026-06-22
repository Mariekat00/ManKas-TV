import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: "https://b5d693a48fadce503f209ae990b07e28@o4509386727882752.ingest.de.sentry.io/4509386732798032",
  tracesSampleRate: 0.2,
});
