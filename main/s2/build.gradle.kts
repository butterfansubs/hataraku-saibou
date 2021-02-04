import myaa.subkt.ass.*
import myaa.subkt.tasks.*
import myaa.subkt.tasks.Mux.*
import myaa.subkt.tasks.Nyaa.*
import java.awt.Color
import java.time.*

plugins {
    id("myaa.subkt")
}

fun getGitHash(): String {
    val proc = ProcessBuilder("git", "rev-parse", "HEAD")
            .redirectOutput(ProcessBuilder.Redirect.PIPE)
            .start()

    return proc.inputStream.reader().readText().trim() ?: ""
}

subs {
    readProperties("sub.properties", "private.properties")
    episodes(getList("episodes"))

    val meta by task<ASS> {
        from(get("meta"))

        val git_hash = getGitHash()

        ass {
            for (line in events.lines) {
                if (line.comment) {
                    line.text = line.text.replace("%GIT_HASH%", git_hash)
                }
            }
        }
    }

    merge {
        from(meta.item())

        from(get("dialogue")) {
            incrementLayer(10)
        }

        from(getList("typesetting"))

        from(get("OP")) {
            syncSourceLine("sync", EventLineAccessor.EFFECT)
            syncTargetLine("OP", EventLineAccessor.TEXT)
        }

        from(get("ED")) {
            syncSourceLine("sync", EventLineAccessor.EFFECT)
            syncTargetLine("ED", EventLineAccessor.TEXT)
        }

        includeProjectGarbage(false)
        includeExtraData(false)

        out(get("mergefile"))
    }

    chapters {
        from(get("chapters"))
    }

    mux {
        // uncomment this line to disable font validation if necessary
        // verifyFonts(false)

        title(get("title"))

        from(get("premux")) {
            video {
                lang("jpn")
                default(true)
            }
            audio {
                lang("jpn")
                default(true)
            }
            includeChapters(false)
            attachments { include(false) }
        }

        from(merge.item()) {
            tracks {
                name(get("group"))
                lang("eng")
                default(true)
            }
        }

        chapters(chapters.item()) {
            lang("eng")
        }

        attach(get("commonfonts")) {
            includeExtensions("ttf", "otf")
        }
        attach(get("epfonts")) {
            includeExtensions("ttf", "otf")
        }

        if (file(get("OP")).exists()) {
            attach(get("OPfonts")) {
                includeExtensions("ttf", "otf")
            }
        }

        if (file(get("ED")).exists()) {
            attach(get("EDfonts")) {
                includeExtensions("ttf", "otf")
            }
        }

        out(get("muxfile"))
    }
}
