
\restrict 7Hv1jf5kX9ARcVFsgUZo4pU9fVeRPWIBQgB8SaKfrcraxiAcnxIO0E9w8950b6k


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.posts DISABLE TRIGGER ALL;

INSERT INTO public.posts (id, title, body) VALUES ('9aa81a6e-a2d1-4a1c-863b-413c6451d311', 'Hi', 'idk m very condused rn');
INSERT INTO public.posts (id, title, body) VALUES ('aa0dfe6e-1755-47aa-ba71-c6946161a161', 'Hello World', 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam');


ALTER TABLE public.posts ENABLE TRIGGER ALL;


ALTER TABLE public.schema_migrations DISABLE TRIGGER ALL;

INSERT INTO public.schema_migrations (revision) VALUES (1759016004);


ALTER TABLE public.schema_migrations ENABLE TRIGGER ALL;


\unrestrict 7Hv1jf5kX9ARcVFsgUZo4pU9fVeRPWIBQgB8SaKfrcraxiAcnxIO0E9w8950b6k

