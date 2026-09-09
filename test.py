import psycopg


def main():
    conn = psycopg.connect(
        host="localhost",
        port=5432,
        dbname="dashboard",
        user="postgres",
        password="Albert0Ascari!",
    )

    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT ops.update_stats(
                    %s,  -- customer_name
                    %s,  -- component_type
                    %s,  -- component_name
                    %s,  -- total_events
                    %s,  -- total_errors
                    %s   -- average_response_time_ms
                )
                """,
                (
                    "Platform42",
                    "CHANNEL",
                    "WhatsApp",
                    1000,
                    25,
                    312.450,
                ),
            )

        conn.commit()

    except Exception:
        conn.rollback()
        raise

    finally:
        conn.close()


if __name__ == "__main__":
    main()